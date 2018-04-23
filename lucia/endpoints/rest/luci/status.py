import subprocess
from flask_restful import Resource

example_response = """
● sigma.service - Sigma The Database Giant
   Active: active (running) since Sat 2018-04-21 10:04:41 CEST; 2 days ago
 Main PID: 2707 (python3.6)
    Tasks: 70
   Memory: 1.8G
      CPU: 1d 18h 41min 471ms
"""


def load_rest_endpoint(core):
    location = '/rest/luci/status'

    class LuciServiceStatus(Resource):
        def __init__(self):
            self.core = core

        @staticmethod
        def get_status(lines: list):
            status = 'unknown (unknown)'
            for line in lines:
                if line.split(': ')[0] == 'Active':
                    status = " ".join(line.split(': ')[1].split()[:2])
            return status

        @staticmethod
        def get_process(lines: list):
            pid = 0
            exe = 'unknown'
            for line in lines:
                if line.split(': ')[0] == 'Main PID':
                    line_right = line.split(': ')[1]
                    pid = int(line_right.split()[0])
                    exe = line_right.split()[1][1:-1]
            return pid, exe

        @staticmethod
        def get_tasks(lines: list):
            tasks = 0
            for line in lines:
                if line.split(': ')[0] == 'Tasks':
                    line_right = line.split(': ')[1]
                    tasks = int(line_right.split()[0])
            return tasks

        @staticmethod
        def get_memory(lines: list):
            mem = '0.0G'
            for line in lines:
                if line.split(': ')[0] == 'Memory':
                    mem = line.split(': ')[1]
            return mem

        @staticmethod
        def get_cpu_time(lines: list):
            cpu_time = '0d 0h 0min 0s 0ms'
            for line in lines:
                if line.split(': ')[0] == 'CPU':
                    cpu_time = line.split(': ')[1]
            return cpu_time

        def parse_response(self, sys_response: str):
            resp_lines = list(filter(lambda x: x != '', [line.strip() for line in sys_response.split('\n')]))
            service_name, service_description = resp_lines[0].split(' - ')
            service_pid, service_exe = self.get_process(resp_lines)
            info = {
                'name': service_name[2:].split('.')[0],
                'desc': service_description,
                'status': self.get_status(resp_lines),
                'pid': service_pid,
                'executable': service_exe,
                'tasks': self.get_tasks(resp_lines),
                'memory': self.get_memory(resp_lines),
                'cpu_time': self.get_cpu_time(resp_lines)
            }
            return info

        @staticmethod
        def get_systemctl_status(service: str):
            process = subprocess.run(["systemctl", "status", service], stdout=subprocess.PIPE, check=True)
            return process.stdout.decode('utf-8')

        def get(self):
            service_names = ['sigma', 'sigmamusic', 'apdata', 'elastic', 'kibana', 'nginx', 'mongod']
            service_data = []
            for service_name in service_names:
                service_response = self.get_systemctl_status(service_name)
                service_info = self.parse_response(service_response)
                service_data.append(service_info)
            return service_data

    return LuciServiceStatus, location
