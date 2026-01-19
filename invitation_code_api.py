#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
授权码生成系统 - 后端API
提供数据库写入接口
"""
import sys
import io

# 设置标准输出编码为UTF-8（Windows兼容）
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
from mysql.connector import Error
import json
from datetime import datetime
import random
import string
import os

app = Flask(__name__, static_folder='.', static_url_path='')
CORS(app)  # 允许跨域请求

# 加载配置文件
def load_config():
    """从环境变量或config.json加载配置（环境变量优先）"""
    config_path = os.path.join(os.path.dirname(__file__), 'config.json')

    # 先尝试从config.json加载基础配置
    base_config = get_default_config()
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            file_config = json.load(f)
            # 合并文件配置到基础配置
            for key in file_config:
                if key in base_config and isinstance(base_config[key], dict):
                    base_config[key].update(file_config[key])
                else:
                    base_config[key] = file_config[key]
    except FileNotFoundError:
        print(f"⚠️  警告: 配置文件 {config_path} 不存在，使用默认配置")
    except json.JSONDecodeError as e:
        print(f"❌ 错误: 配置文件格式错误 - {e}")
        print("使用默认配置")

    # 环境变量覆盖配置（优先级最高）
    if os.getenv('DB_HOST'):
        base_config['database']['host'] = os.getenv('DB_HOST')
    if os.getenv('DB_PORT'):
        base_config['database']['port'] = int(os.getenv('DB_PORT'))
    if os.getenv('DB_NAME'):
        base_config['database']['database'] = os.getenv('DB_NAME')
    if os.getenv('DB_USER'):
        base_config['database']['user'] = os.getenv('DB_USER')
    if os.getenv('DB_PASSWORD'):
        base_config['database']['password'] = os.getenv('DB_PASSWORD')

    if os.getenv('API_HOST'):
        base_config['api']['host'] = os.getenv('API_HOST')
    if os.getenv('API_PORT'):
        base_config['api']['port'] = int(os.getenv('API_PORT'))
    if os.getenv('API_DEBUG'):
        base_config['api']['debug'] = os.getenv('API_DEBUG').lower() in ('true', '1', 'yes')

    return base_config

def get_default_config():
    """返回默认配置"""
    return {
        "database": {
            "host": "192.168.34.6",
            "port": 10001,
            "database": "clouditera_aigc",
            "user": "root",
            "password": "Clouditera@2023",
            "charset": "utf8mb4",
            "collation": "utf8mb4_unicode_ci"
        },
        "api": {
            "host": "0.0.0.0",
            "port": 30111,
            "debug": True
        },
        "default_values": {
            "expired": "2027-03-01 10:16:00",
            "person_knowledge_count": 3,
            "group_knowledge_count": 10,
            "document_count": 100,
            "created_by": "admin"
        }
    }

# 加载配置
CONFIG = load_config()
DB_CONFIG = CONFIG['database']
API_CONFIG = CONFIG['api']
DEFAULT_VALUES = CONFIG['default_values']

def get_db_connection():
    """获取数据库连接"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        print(f"数据库连接错误: {e}")
        return None

def check_code_exists(code, connection=None):
    """检查授权码是否已存在（优化：使用EXISTS查询和可选的连接复用）"""
    close_conn = False
    if connection is None:
        connection = get_db_connection()
        close_conn = True
        if not connection:
            return False
    
    try:
        cursor = connection.cursor()
        # 使用EXISTS查询，比COUNT(*)更高效
        query = "SELECT 1 FROM INVITATION_CODE WHERE CODE = %s LIMIT 1"
        cursor.execute(query, (code,))
        result = cursor.fetchone()
        return result is not None
    except Error as e:
        print(f"检查授权码错误: {e}")
        return False
    finally:
        if connection.is_connected():
            cursor.close()
        if close_conn:
            connection.close()

def generate_unique_code():
    """生成唯一的6位授权码（优化：复用数据库连接，减少查询次数）"""
    chars = string.ascii_uppercase + string.digits
    max_attempts = 50  # 减少尝试次数，提高速度
    
    # 复用数据库连接，避免每次都创建新连接
    connection = get_db_connection()
    if not connection:
        raise Exception("数据库连接失败")
    
    try:
        cursor = connection.cursor()
        # 批量生成多个候选码，减少数据库查询次数
        candidates = [''.join(random.choices(chars, k=6)) for _ in range(min(10, max_attempts))]
        
        for code in candidates:
            query = "SELECT 1 FROM INVITATION_CODE WHERE CODE = %s LIMIT 1"
            cursor.execute(query, (code,))
            result = cursor.fetchone()
            if not result:
                return code
        
        # 如果批量检查都没找到，继续单个检查
        for _ in range(max_attempts - len(candidates)):
            code = ''.join(random.choices(chars, k=6))
            cursor.execute("SELECT 1 FROM INVITATION_CODE WHERE CODE = %s LIMIT 1", (code,))
            if not cursor.fetchone():
                return code
        raise Exception("无法生成唯一授权码，请重试")
    finally:
        if connection.is_connected():
            if 'cursor' in locals():
                cursor.close()
            connection.close()

@app.route('/')
def index():
    """前端UI页面"""
    return app.send_static_file('invitation_code_generator.html')

@app.route('/manager')
def manager():
    """授权码管理页面"""
    return app.send_static_file('invitation_code_manager.html')

@app.route('/api/check-code', methods=['POST'])
def check_code():
    """检查授权码是否可用"""
    try:
        data = request.json
        code = data.get('code', '').upper()
        
        if not code or len(code) != 6:
            return jsonify({
                'success': False,
                'message': '授权码格式不正确'
            }), 400
        
        exists = check_code_exists(code)
        
        return jsonify({
            'success': True,
            'exists': exists,
            'available': not exists
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'检查失败: {str(e)}'
        }), 500

@app.route('/api/generate-code', methods=['GET'])
def generate_code():
    """生成新的唯一授权码"""
    try:
        code = generate_unique_code()
        return jsonify({
            'success': True,
            'code': code
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'生成失败: {str(e)}'
        }), 500

@app.route('/api/create-invitation', methods=['POST'])
def create_invitation():
    """创建授权码并写入数据库"""
    try:
        data = request.json
        
        # 验证必填字段
        required_fields = ['code', 'size', 'beginDate', 'endDate', 'tokens', 'agents', 'sastQuota', 'sastQuotaPeriod']
        for field in required_fields:
            if field not in data:
                return jsonify({
                    'success': False,
                    'message': f'缺少必填字段: {field}'
                }), 400
        
        code = data['code'].upper()
        
        # 检查授权码是否已存在
        if check_code_exists(code):
            return jsonify({
                'success': False,
                'message': '授权码已存在，请重新生成'
            }), 400
        
        # 验证sastQuotaPeriod的值
        sast_quota_period = data.get('sastQuotaPeriod', 'daily').lower()
        valid_periods = ['daily', 'weekly', 'monthly']
        if sast_quota_period not in valid_periods:
            return jsonify({
                'success': False,
                'message': f'无效的使用频率值: {sast_quota_period}，必须是 {valid_periods} 之一'
            }), 400
        
        # 构建CODE_INFO JSON
        code_info = {
            'size': int(data['size']),
            'beginDate': data['beginDate'],
            'endDate': data['endDate'],
            'tokens': int(data['tokens']),
            'agents': data['agents'],
            'sastQuota': int(data['sastQuota']),
            'sastQuotaPeriod': sast_quota_period
        }
        
        # 默认字段（从配置文件读取）
        expired = DEFAULT_VALUES['expired']
        person_knowledge_count = DEFAULT_VALUES['person_knowledge_count']
        group_knowledge_count = DEFAULT_VALUES['group_knowledge_count']
        document_count = DEFAULT_VALUES['document_count']
        created_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        created_by = DEFAULT_VALUES['created_by']
        
        # 插入数据库
        connection = get_db_connection()
        if not connection:
            return jsonify({
                'success': False,
                'message': '数据库连接失败'
            }), 500
        
        try:
            cursor = connection.cursor()
            
            # 确保ID字段设置为AUTO_INCREMENT（如果还没有设置）
            # 注意：这个操作只需要执行一次，但为了确保兼容性，每次插入前都尝试设置
            try:
                alter_query = "ALTER TABLE INVITATION_CODE MODIFY ID INT AUTO_INCREMENT"
                cursor.execute(alter_query)
                connection.commit()
            except Error as e:
                # 如果已经设置为AUTO_INCREMENT，会报错但可以忽略
                # 其他错误也会被忽略，让插入操作继续
                connection.rollback()
                pass
            
            # 在插入前再次检查授权码是否已存在（防止并发问题，优化：使用EXISTS）
            check_query = "SELECT 1 FROM INVITATION_CODE WHERE CODE = %s LIMIT 1"
            cursor.execute(check_query, (code,))
            result = cursor.fetchone()
            if result:
                connection.rollback()
                return jsonify({
                    'success': False,
                    'message': '授权码已存在，请重新生成'
                }), 400
            
            # 插入数据（不包含ID字段，让数据库自动生成）
            # 使用数据库唯一约束作为最后一道防线
            insert_query = """
            INSERT INTO INVITATION_CODE 
            (CODE, CODE_INFO, EXPIRED, PERSON_KNOWLEDGE_COUNT, GROUP_KNOWLEDGE_COUNT, DOCUMENT_COUNT, CREATED_TIME, CREATED_BY)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            
            values = (
                code,
                json.dumps(code_info, ensure_ascii=False),
                expired,
                person_knowledge_count,
                group_knowledge_count,
                document_count,
                created_time,
                created_by
            )
            
            try:
                cursor.execute(insert_query, values)
                connection.commit()
            except Error as e:
                # 处理数据库唯一约束违反错误（Duplicate entry）
                error_code = e.errno if hasattr(e, 'errno') else None
                if error_code == 1062:  # MySQL duplicate entry error
                    connection.rollback()
                    return jsonify({
                        'success': False,
                        'message': '授权码已存在（数据库唯一约束），请重新生成'
                    }), 400
                else:
                    # 其他数据库错误
                    connection.rollback()
                    raise
            
            # 获取插入的ID
            inserted_id = cursor.lastrowid
            
            return jsonify({
                'success': True,
                'message': '授权码创建成功',
                'data': {
                    'id': inserted_id,
                    'code': code,
                    'codeInfo': code_info,
                    'createdTime': created_time
                }
            })
            
        except Error as e:
            connection.rollback()
            return jsonify({
                'success': False,
                'message': f'数据库操作失败: {str(e)}'
            }), 500
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()
                
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'创建失败: {str(e)}'
        }), 500

@app.route('/api/get-invitation/<code>', methods=['GET'])
def get_invitation(code):
    """查询授权码信息"""
    try:
        code = code.upper()
        
        connection = get_db_connection()
        if not connection:
            return jsonify({
                'success': False,
                'message': '数据库连接失败'
            }), 500
        
        try:
            cursor = connection.cursor()
            query = "SELECT ID, CODE, CODE_INFO, EXPIRED, PERSON_KNOWLEDGE_COUNT, GROUP_KNOWLEDGE_COUNT, DOCUMENT_COUNT, CREATED_TIME, CREATED_BY FROM INVITATION_CODE WHERE CODE = %s"
            cursor.execute(query, (code,))
            result = cursor.fetchone()
            
            if not result:
                return jsonify({
                    'success': False,
                    'message': '授权码不存在'
                }), 404
            
            # 解析CODE_INFO JSON
            code_info = json.loads(result[2]) if result[2] else {}
            
            # 格式化返回数据
            return jsonify({
                'success': True,
                'data': {
                    'id': result[0],
                    'code': result[1],
                    'codeInfo': code_info,
                    'expired': result[3].strftime('%Y-%m-%d %H:%M:%S') if result[3] else None,
                    'personKnowledgeCount': result[4],
                    'groupKnowledgeCount': result[5],
                    'documentCount': result[6],
                    'createdTime': result[7].strftime('%Y-%m-%d %H:%M:%S') if result[7] else None,
                    'createdBy': result[8]
                }
            })
            
        except Error as e:
            return jsonify({
                'success': False,
                'message': f'数据库操作失败: {str(e)}'
            }), 500
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()
                
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'查询失败: {str(e)}'
        }), 500

@app.route('/api/update-invitation/<code>', methods=['PUT'])
def update_invitation(code):
    """更新授权码信息"""
    try:
        code = code.upper()
        data = request.json
        
        # 验证必填字段
        required_fields = ['size', 'beginDate', 'endDate', 'tokens', 'agents', 'sastQuota', 'sastQuotaPeriod']
        for field in required_fields:
            if field not in data:
                return jsonify({
                    'success': False,
                    'message': f'缺少必填字段: {field}'
                }), 400
        
        # 验证sastQuotaPeriod的值
        sast_quota_period = data.get('sastQuotaPeriod', 'daily').lower()
        valid_periods = ['daily', 'weekly', 'monthly']
        if sast_quota_period not in valid_periods:
            return jsonify({
                'success': False,
                'message': f'无效的使用频率值: {sast_quota_period}，必须是 {valid_periods} 之一'
            }), 400
        
        # 构建CODE_INFO JSON
        code_info = {
            'size': int(data['size']),
            'beginDate': data['beginDate'],
            'endDate': data['endDate'],
            'tokens': int(data['tokens']),
            'agents': data['agents'],
            'sastQuota': int(data['sastQuota']),
            'sastQuotaPeriod': sast_quota_period
        }
        
        connection = get_db_connection()
        if not connection:
            return jsonify({
                'success': False,
                'message': '数据库连接失败'
            }), 500
        
        try:
            cursor = connection.cursor()
            
            # 先检查授权码是否存在
            check_query = "SELECT ID FROM INVITATION_CODE WHERE CODE = %s"
            cursor.execute(check_query, (code,))
            result = cursor.fetchone()
            if not result:
                return jsonify({
                    'success': False,
                    'message': '授权码不存在'
                }), 404
            
            # 更新数据
            update_query = """
            UPDATE INVITATION_CODE 
            SET CODE_INFO = %s
            WHERE CODE = %s
            """
            
            cursor.execute(update_query, (json.dumps(code_info, ensure_ascii=False), code))
            connection.commit()
            
            return jsonify({
                'success': True,
                'message': '授权码更新成功',
                'data': {
                    'code': code,
                    'codeInfo': code_info
                }
            })
            
        except Error as e:
            connection.rollback()
            return jsonify({
                'success': False,
                'message': f'数据库操作失败: {str(e)}'
            }), 500
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()
                
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'更新失败: {str(e)}'
        }), 500

@app.route('/api/health', methods=['GET'])
def health_check():
    """健康检查"""
    try:
        connection = get_db_connection()
        if connection:
            connection.close()
            return jsonify({
                'success': True,
                'message': '服务正常',
                'database': 'connected'
            })
        else:
            return jsonify({
                'success': False,
                'message': '数据库连接失败'
            }), 500
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'健康检查失败: {str(e)}'
        }), 500

def init_database():
    """初始化数据库表结构"""
    try:
        connection = get_db_connection()
        if not connection:
            print("⚠️  警告: 无法连接数据库，跳过表结构初始化")
            return
        
        cursor = connection.cursor()
        try:
            # 确保ID字段设置为AUTO_INCREMENT
            alter_query = "ALTER TABLE INVITATION_CODE MODIFY ID INT AUTO_INCREMENT"
            cursor.execute(alter_query)
            connection.commit()
            print("✅ 数据库表结构已初始化（ID字段已设置为AUTO_INCREMENT）")
            
            # 尝试为CODE字段添加索引（如果不存在），提升查询性能
            try:
                index_query = "CREATE INDEX idx_code ON INVITATION_CODE(CODE)"
                cursor.execute(index_query)
                connection.commit()
                print("✅ CODE字段索引已创建")
            except Error:
                # 索引可能已存在，忽略错误
                connection.rollback()
        except Error as e:
            # 如果已经设置或表不存在，忽略错误
            error_code = e.errno if hasattr(e, 'errno') else None
            if error_code == 1060:  # Duplicate column name
                print("ℹ️  ID字段已设置为AUTO_INCREMENT")
            else:
                print(f"ℹ️  表结构检查完成: {str(e)}")
            connection.rollback()
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()
    except Exception as e:
        print(f"⚠️  数据库初始化警告: {str(e)}")

if __name__ == '__main__':
    # 初始化数据库表结构
    print("正在初始化数据库表结构...")
    init_database()
    print()
    print("=" * 50)
    print("授权码生成系统 - 集成服务（API + UI）")
    print("=" * 50)
    print(f"数据库: {DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}")
    print(f"API服务: http://{API_CONFIG['host']}:{API_CONFIG['port']}")
    print("=" * 50)
    print("访问路径:")
    print("  GET  /                    - 前端UI界面")
    print("  GET  /api/health          - 健康检查")
    print("  GET  /api/generate-code   - 生成授权码")
    print("  POST /api/check-code      - 检查授权码")
    print("  POST /api/create-invitation - 创建授权码")
    print("=" * 50)
    config_file_path = os.path.join(os.path.dirname(__file__), 'config.json')
    print(f"配置文件: {config_file_path}")
    print("=" * 50)
    print()
    
    app.run(
        host=API_CONFIG['host'],
        port=API_CONFIG['port'],
        debug=API_CONFIG['debug']
    )

