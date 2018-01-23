import errno
import os
import secrets

import yaml


class FlaskConfig(object):
    def __init__(self, data):
        self.raw = data
        self.host = self.raw.get('host') or '127.0.0.1'
        self.port = self.raw.get('port') or 8080
        self.debug = self.raw.get('debug')
        self.secret = self.raw.get('secret') or secrets.token_hex(4)
        self.sigma = self.raw.get('sigma')
        self.cors = self.raw.get('cors') or []
        self.token = self.raw.get('token') or 'no_token'
        print(self.debug)


class MongoConfig(object):
    def __init__(self, data):
        self.raw = data
        self.host = self.raw.get('host') or '127.0.0.1'
        self.port = self.raw.get('port') or 27017
        self.auth = self.raw.get('auth') or False
        self.user = self.raw.get('user')
        self.pasw = self.raw.get('pasw')


class Configuration(object):
    def __init__(self):
        self.not_found = False
        self.flask_config_location = 'config/flask.yml'
        self.mongo_config_location = 'config/mongo.yml'
        if os.path.exists(self.flask_config_location):
            with open(self.flask_config_location) as flask_config_file:
                flask_config_data = yaml.safe_load(flask_config_file)
                self.app = FlaskConfig(flask_config_data)
        else:
            self.not_found = True
        if os.path.exists(self.mongo_config_location):
            with open(self.mongo_config_location) as mongo_config_file:
                mongo_config_data = yaml.safe_load(mongo_config_file)
                self.db = MongoConfig(mongo_config_data)
        else:
            self.not_found = True
        if self.not_found:
            print('Could not find all configuration files.')
            exit(errno.ENOENT)
