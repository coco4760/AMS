#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
智能Docker镜像管理器
支持重复检测、快速加载和压缩
"""

import os
import sys
import yaml
import argparse
import subprocess
import json
from datetime import datetime
from typing import Dict, List, Any
import concurrent.futures

class SmartImageManager:
    def __init__(self, config_file: str):
        self.config_file = config_file
        self.config = self.load_config()
        self.registry = self.config.get('registry', 'rd.clouditera.com')
        
    def load_config(self) -> Dict[str, Any]:
        """加载配置文件"""
        try:
            with open(self.config_file, 'r', encoding='utf-8') as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            print(f"错误: 配置文件 {self.config_file} 不存在")
            sys.exit(1)
        except yaml.YAMLError as e:
            print(f"错误: 配置文件格式错误: {e}")
            sys.exit(1)
    
    def get_images_for_environment(self, environment: str) -> List[Dict[str, Any]]:
        """获取指定环境的镜像列表"""
        env_config = self.config.get('environments', {}).get(environment)
        if not env_config:
            print(f"错误: 环境 {environment} 不存在")
            return []
        
        required_categories = env_config.get('required_categories', [])
        all_images = []
        
        for category_name in required_categories:
            category = self.config.get('categories', {}).get(category_name)
            if category:
                for image in category.get('images', []):
                    image_copy = image.copy()
                    image_copy['category'] = category_name
                    image_copy['category_name'] = category.get('name', category_name)
                    all_images.append(image_copy)
        
        return all_images
    
    def get_full_image_name(self, image_name: str, tag: str) -> str:
        """获取完整的镜像名称"""
        # 如果镜像名称已经包含完整路径（包含registry），直接返回
        if image_name.startswith('rd.clouditera.com/') or image_name.startswith('docker.io/') or image_name.startswith('quay.io/'):
            return f"{image_name}:{tag}"
        # 如果镜像名称包含路径但不包含registry，添加registry前缀
        elif '/' in image_name:
            return f"{self.registry}/{image_name}:{tag}"
        # 如果只是镜像名，添加registry前缀
        else:
            return f"{self.registry}/{image_name}:{tag}"
    
    def is_image_exists(self, image_name: str) -> bool:
        """检查镜像是否已存在"""
        try:
            result = subprocess.run(
                ['docker', 'images', '--format', '{{.Repository}}:{{.Tag}}', image_name],
                capture_output=True, text=True, check=True
            )
            return bool(result.stdout.strip())
        except subprocess.CalledProcessError:
            return False
    
    def download_image(self, image_info: Dict[str, Any], tag: str, skip_existing: bool = True) -> bool:
        """下载单个镜像（支持重复检测）"""
        full_name = self.get_full_image_name(image_info['name'], tag)
        category_name = image_info.get('category_name', 'Unknown')
        
        print(f"  [{category_name}] 处理镜像: {full_name}")
        
        # 检查是否已存在
        if skip_existing and self.is_image_exists(full_name):
            print(f"    ⚡ 镜像已存在，跳过下载")
            return True
        
        print(f"    📥 开始下载镜像: {full_name}")
        
        try:
            result = subprocess.run(
                ['docker', 'pull', full_name],
                capture_output=True, text=True, check=True
            )
            print(f"    ✅ 下载成功: {full_name}")
            return True
            
        except subprocess.CalledProcessError as e:
            print(f"    ❌ 下载失败: {full_name}")
            print(f"      错误: {e.stderr}")
            return False
    
    def download_images(self, environment: str, tags: List[str] = None, 
                       parallel: bool = True, skip_existing: bool = True) -> Dict[str, Any]:
        """下载指定环境的镜像"""
        if tags is None:
            tags = ["latest"]  # 使用配置文件中的第一个标签
        
        images = self.get_images_for_environment(environment)
        if not images:
            print(f"环境 {environment} 没有找到镜像配置")
            return {'success': 0, 'failed': 0, 'total': 0, 'skipped': 0}
        
        print(f"开始下载环境 {environment} 的镜像...")
        print(f"找到 {len(images)} 个镜像")
        print("=" * 60)
        
        total_downloads = len(images)
        success_count = 0
        failed_count = 0
        skipped_count = 0
        
        if parallel:
            max_workers = self.config.get('download_strategy', {}).get('parallel_downloads', 3)
            print(f"使用并行下载，最大并发数: {max_workers}")
            
            with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
                futures = []
                for image_info in images:
                    # 使用第一个标签
                    tag = image_info.get('tags', ['latest'])[0]
                    future = executor.submit(self.download_image, image_info, tag, skip_existing)
                    futures.append(future)
                
                for future in concurrent.futures.as_completed(futures):
                    if future.result():
                        success_count += 1
                    else:
                        failed_count += 1
        else:
            print("使用串行下载")
            for image_info in images:
                tag = image_info.get('tags', ['latest'])[0]
                if self.download_image(image_info, tag, skip_existing):
                    success_count += 1
                else:
                    failed_count += 1
        
        print("=" * 60)
        print(f"下载完成！成功: {success_count}, 失败: {failed_count}, 总计: {total_downloads}")
        
        return {
            'success': success_count,
            'failed': failed_count,
            'total': total_downloads,
            'skipped': skipped_count
        }
    
    def save_images(self, environment: str, output_dir: str = None, 
                   compress: bool = True) -> str:
        """保存镜像为tar文件（支持压缩）"""
        images = self.get_images_for_environment(environment)
        if not images:
            print(f"环境 {environment} 没有找到镜像配置")
            return ""
        
        if output_dir is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_dir = f"docker-images-{environment}-{timestamp}"
        
        os.makedirs(output_dir, exist_ok=True)
        print(f"开始保存镜像到目录: {output_dir}")
        
        success_count = 0
        failed_count = 0
        total_size = 0
        
        for image_info in images:
            tag = image_info.get('tags', ['latest'])[0]
            full_name = self.get_full_image_name(image_info['name'], tag)
            filename = f"{image_info['name'].replace('/', '_').replace(':', '_')}_{tag}.tar"
            filepath = os.path.join(output_dir, filename)
            
            print(f"保存镜像: {full_name} -> {filepath}")
            
            try:
                result = subprocess.run(
                    ['docker', 'save', '-o', filepath, full_name],
                    capture_output=True, text=True, check=True
                )
                
                # 获取文件大小
                file_size = os.path.getsize(filepath)
                total_size += file_size
                
                print(f"  ✅ 保存成功 ({self.format_size(file_size)})")
                success_count += 1
                
            except subprocess.CalledProcessError as e:
                print(f"  ❌ 保存失败: {e.stderr}")
                failed_count += 1
        
        # 创建压缩包
        if compress:
            tar_file = f"{output_dir}.tar.gz"
            print(f"创建压缩包: {tar_file}")
            
            try:
                subprocess.run(['tar', '-czf', tar_file, output_dir], check=True)
                compressed_size = os.path.getsize(tar_file)
                
                print(f"压缩包创建成功: {tar_file}")
                if total_size > 0:
                    compression_ratio = (1 - compressed_size / total_size) * 100
                    print(f"原始大小: {self.format_size(total_size)}")
                    print(f"压缩后大小: {self.format_size(compressed_size)}")
                    print(f"压缩率: {compression_ratio:.1f}%")
                else:
                    print("没有镜像被保存，压缩包为空")
                
                # 清理临时目录
                import shutil
                shutil.rmtree(output_dir)
                print(f"临时目录已清理: {output_dir}")
                    
            except subprocess.CalledProcessError as e:
                print(f"压缩包创建失败: {e}")
                tar_file = output_dir
        else:
            tar_file = output_dir
        
        print(f"保存完成！成功: {success_count}, 失败: {failed_count}")
        return tar_file
    
    def load_images(self, tar_file: str, parallel: bool = True) -> Dict[str, Any]:
        """从tar文件快速加载镜像"""
        if not os.path.exists(tar_file):
            print(f"错误: 文件不存在 {tar_file}")
            return {'success': 0, 'failed': 0, 'total': 0}
        
        # 如果是压缩包，先解压
        if tar_file.endswith('.tar.gz'):
            print(f"解压文件: {tar_file}")
            extract_dir = tar_file.replace('.tar.gz', '')
            try:
                subprocess.run(['tar', '-xzf', tar_file], check=True)
                tar_file = extract_dir
            except subprocess.CalledProcessError as e:
                print(f"解压失败: {e}")
                return {'success': 0, 'failed': 0, 'total': 0}
        
        if not os.path.isdir(tar_file):
            print(f"错误: {tar_file} 不是目录")
            return {'success': 0, 'failed': 0, 'total': 0}
        
        # 查找所有tar文件
        tar_files = [f for f in os.listdir(tar_file) if f.endswith('.tar')]
        if not tar_files:
            print(f"错误: 目录 {tar_file} 中没有找到tar文件")
            return {'success': 0, 'failed': 0, 'total': 0}
        
        print(f"开始加载 {len(tar_files)} 个镜像...")
        
        success_count = 0
        failed_count = 0
        
        if parallel:
            max_workers = min(len(tar_files), 4)
            print(f"使用并行加载，最大并发数: {max_workers}")
            
            with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
                futures = []
                for tar_filename in tar_files:
                    tar_path = os.path.join(tar_file, tar_filename)
                    future = executor.submit(self.load_single_image, tar_path)
                    futures.append(future)
                
                for future in concurrent.futures.as_completed(futures):
                    if future.result():
                        success_count += 1
                    else:
                        failed_count += 1
        else:
            print("使用串行加载")
            for tar_filename in tar_files:
                tar_path = os.path.join(tar_file, tar_filename)
                if self.load_single_image(tar_path):
                    success_count += 1
                else:
                    failed_count += 1
        
        print(f"加载完成！成功: {success_count}, 失败: {failed_count}, 总计: {len(tar_files)}")
        
        # 清理解压的目录
        if tar_file != extract_dir and os.path.exists(extract_dir):
            import shutil
            shutil.rmtree(extract_dir)
            print(f"解压目录已清理: {extract_dir}")
        
        return {
            'success': success_count,
            'failed': failed_count,
            'total': len(tar_files)
        }
    
    def load_single_image(self, tar_path: str) -> bool:
        """加载单个镜像文件"""
        filename = os.path.basename(tar_path)
        print(f"加载镜像: {filename}")
        
        try:
            result = subprocess.run(
                ['docker', 'load', '-i', tar_path],
                capture_output=True, text=True, check=True
            )
            print(f"  ✅ 加载成功: {filename}")
            return True
        except subprocess.CalledProcessError as e:
            print(f"  ❌ 加载失败: {filename}")
            print(f"    错误: {e.stderr}")
            return False
    
    def format_size(self, size_bytes: int) -> str:
        """格式化文件大小"""
        if size_bytes == 0:
            return "0B"
        
        size_names = ["B", "KB", "MB", "GB", "TB"]
        i = 0
        while size_bytes >= 1024 and i < len(size_names) - 1:
            size_bytes /= 1024.0
            i += 1
        
        return f"{size_bytes:.1f}{size_names[i]}"
    
    def show_statistics(self, environment: str):
        """显示镜像统计信息"""
        images = self.get_images_for_environment(environment)
        if not images:
            print(f"环境 {environment} 没有找到镜像配置")
            return
        
        print(f"环境 {environment} 镜像统计信息")
        print("=" * 50)
        
        # 按分类统计
        categories = {}
        for image in images:
            category = image.get('category_name', 'Unknown')
            if category not in categories:
                categories[category] = 0
            categories[category] += 1
        
        for category, count in categories.items():
            print(f"{category}: {count} 个镜像")
        
        print(f"总计: {len(images)} 个镜像")

def main():
    parser = argparse.ArgumentParser(description='智能Docker镜像管理器')
    parser.add_argument('--config', '-c', required=True, help='配置文件路径')
    parser.add_argument('--env', '-e', help='目标环境')
    parser.add_argument('--action', '-a', 
                       choices=['download', 'save', 'load', 'stats'], 
                       default='download', help='执行操作')
    parser.add_argument('--parallel', '-p', action='store_true', help='启用并行操作')
    parser.add_argument('--output-dir', '-o', help='输出目录')
    parser.add_argument('--tar-file', help='要加载的tar文件')
    parser.add_argument('--skip-existing', action='store_true', default=True, help='跳过已存在的镜像')
    parser.add_argument('--compress', action='store_true', default=True, help='启用压缩')
    
    args = parser.parse_args()
    
    # 创建管理器
    manager = SmartImageManager(args.config)
    
    # 执行操作
    if args.action == 'stats':
        if args.env:
            manager.show_statistics(args.env)
        else:
            print("请指定环境 (--env)")
        return
    
    if args.action == 'load':
        if not args.tar_file:
            print("错误: 需要指定tar文件 (--tar-file)")
            return
        manager.load_images(args.tar_file, args.parallel)
        return
    
    if not args.env:
        print("错误: 需要指定目标环境 (--env)")
        return
    
    if args.action == 'download':
        result = manager.download_images(args.env, parallel=args.parallel, skip_existing=args.skip_existing)
        if result['failed'] > 0:
            print(f"警告: {result['failed']} 个镜像下载失败")
    
    elif args.action == 'save':
        output_file = manager.save_images(args.env, args.output_dir, args.compress)
        if output_file:
            print(f"镜像已保存到: {output_file}")

if __name__ == '__main__':
    main()
