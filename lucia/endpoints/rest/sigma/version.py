import os

import yaml
from flask_restful import Resource


def load_rest_endpoint(core):
    location = '/rest/sigma/version'

    class SigmaVersion(Resource):
        def __init__(self):
            self.core = core

        @staticmethod
        def get():
            if core.cfg.app.sigma:
                version_path = f'{core.cfg.app.sigma}/info/version.yml'
                if os.path.exists(version_path):
                    with open(version_path, encoding='utf-8') as version_file:
                        ver_data = yaml.safe_load(version_file)
                else:
                    ver_data = {'error': 'Version file not found.'}
            else:
                ver_data = {'error': 'Sigma location not set.'}
            return ver_data

    return SigmaVersion, location
