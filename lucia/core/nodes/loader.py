import importlib
import os


class EndpointLoader(object):
    def __init__(self, core):
        self.core = core
        self.rest_dir = 'lucia/endpoints/rest'
        self.webs_rid = 'lucia/endpoints/webs'
        self.load_restfuls()
        self.load_websockets()

    def load_restfuls(self):
        print('--------------------------------')
        print('Loading REST Endpoints')
        print('--------------------------------')
        for root, dirs, files in os.walk(self.rest_dir):
            for file in files:
                if file.endswith('.py'):
                    file = file[:-3]
                    module_path = os.path.join(root, file)
                    module_location = module_path.replace('/', '.').replace('\\', '.')
                    resource, location = importlib.import_module(module_location).load_rest_endpoint(self.core)
                    self.core.rest.add_resource(resource, location)
                    print(f'Added REST [{resource.__name__}] at [{location}]')

    def load_websockets(self):
        print('--------------------------------')
        print('Loading WEBS Endpoints')
        print('--------------------------------')
        for root, dirs, files in os.walk(self.webs_rid):
            for file in files:
                if file.endswith('.py'):
                    file = file[:-3]
                    module_path = os.path.join(root, file)
                    module_location = module_path.replace('/', '.').replace('\\', '.')
                    resource, location = importlib.import_module(module_location).load_webs_endpoint(self.core)
                    namespace = resource(location)
                    self.core.webs.on_namespace(namespace)
                    print(f'Added WEBS [{resource.__name__}] at [{location}]')
