#!/usr/bin/env python3
"""
TCP Gateway for Harbor - proxies requests to backend services
"""

import socket
import threading
import json
import os

class Gateway:
    def __init__(self, gateway_map):
        self.gateway_map = gateway_map
    
    def handle_client(self, client_socket, addr):
        try:
            # 接收請求
            request = client_socket.recv(4096).decode()
            
            # 解析目標端口（簡化版）
            lines = request.split('\r\n')
            host_header = None
            for line in lines:
                if line.startswith('Host:'):
                    host_header = line.split(':')[1].strip()
                    break
            
            # 提取端口
            target_port = None
            if host_header:
                parts = host_header.split(':')
                if len(parts) > 1:
                    try:
                        target_port = int(parts[1])
                    except:
                        pass
            
            if not target_port:
                client_socket.close()
                return
            
            # 查找對應的後端服務
            if str(target_port) not in self.gateway_map:
                client_socket.send(b"HTTP/1.1 503 Service Unavailable\r\n\r\n")
                client_socket.close()
                return
            
            backend = self.gateway_map[str(target_port)]
            backend_host = backend.get('host')
            backend_port = backend.get('port')
            
            # 連接到後端服務
            backend_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            backend_socket.connect((backend_host, backend_port))
            
            # 轉發請求
            backend_socket.sendall(request.encode())
            
            # 接收回應並轉發
            while True:
                data = backend_socket.recv(4096)
                if not data:
                    break
                client_socket.sendall(data)
            
            backend_socket.close()
            client_socket.close()
        
        except Exception as e:
            print(f"Error: {e}")
            client_socket.close()
    
    def start(self, listen_port=8000):
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind(('0.0.0.0', listen_port))
        server.listen(5)
        print(f"Gateway listening on port {listen_port}")
        
        try:
            while True:
                client_socket, addr = server.accept()
                thread = threading.Thread(
                    target=self.handle_client,
                    args=(client_socket, addr)
                )
                thread.daemon = True
                thread.start()
        except KeyboardInterrupt:
            server.close()

if __name__ == '__main__':
    # 從環境變數讀取 gateway map
    gateway_map_str = os.getenv('CYBERBENCH_GATEWAY_MAP', '{}')
    try:
        gateway_map = json.loads(gateway_map_str)
    except:
        gateway_map = {}
    
    gateway = Gateway(gateway_map)
    gateway.start(listen_port=8000)
