#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
授权码生成系统 - 后端API
提供数据库写入接口
生产环境入口文件
"""
from invitation_code_api import app

if __name__ == '__main__':
    import os
    from invitation_code_api import API_CONFIG
    
    port = int(os.environ.get('PORT', API_CONFIG['port']))
    host = os.environ.get('HOST', API_CONFIG['host'])
    
    app.run(host=host, port=port, debug=API_CONFIG['debug'])

