import json

import arrow
from flask_socketio import Namespace, emit


def load_webs_endpoint(core):
    location = '/webs/sigma/stats'

    class SigmaStatistics(Namespace):
        def __init__(self, namespace):
            super().__init__(namespace)
            self.core = core

        @staticmethod
        def on_connect():
            print('Client connected.')

        @staticmethod
        def on_disconnect():
            print('Client disconnected.')

        def on_test(self, data):
            out_data = json.dumps({
                'now': arrow.utcnow().float_timestamp,
                'start': self.core.start.float_timestamp
            })
            emit('current_time', out_data)
            print(data)

    return SigmaStatistics, location
