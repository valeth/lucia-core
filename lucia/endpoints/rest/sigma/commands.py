import os

import arrow
import yaml
from flask_restful import Resource


def load_rest_endpoint(core):
    location = '/rest/sigma/commands'

    class CommandsEndpoint(Resource):
        def __init__(self):
            self.core = core
            self.modules = []
            self.cache_stamp = 0
            self.icons = {
                'music': 'music',
                'minigames': 'target',
                'roles': 'tag',
                'fun': 'sun',
                'development': 'gh',
                'utility': 'command',
                'games': 'crosshair',
                'shop': 'credit-card',
                'moderation': 'shield',
                'points': 'award',
                'interactions': 'at-sign',
                'nihongo': 'book',
                'searches': 'search',
                'nsfw': 'moon',
                'help': 'info',
                'permissions': 'lock',
                'settings': 'cog',
                'patreon': 'patreon',
                'statistics': 'bar-chart-2',
                'mathematics': 'hash',
                'miscellaneous': 'command',
                'logging': 'shield',
                'league of legends': 'league',
                'path_of_exile': 'sword',
                'overwatch': 'overwatch',
                'warframe': 'warframe',
                'osu': 'osu'
            }

        def load_commands(self):
            now = arrow.utcnow().float_timestamp
            if not self.modules or now > self.cache_stamp + 300:
                modules_temp = {}
                for root, dirs, files in os.walk(core.cfg.app.sigma):
                    for file in files:
                        if file == 'module.yml':
                            file_path = (os.path.join(root, file))
                            with open(file_path) as plugin_file:
                                plugin_data = yaml.safe_load(plugin_file)
                                if 'commands' in plugin_data:
                                    if plugin_data['enabled']:
                                        category = plugin_data['category']
                                        if category != 'special':
                                            for cmd in plugin_data['commands']:
                                                if cmd['enabled']:
                                                    if cmd.get('permissions'):
                                                        prms = cmd.get('permissions')
                                                    else:
                                                        prms = {}
                                                    partner = False
                                                    if 'partner' in prms:
                                                        partner = prms['partner']
                                                    admin = False
                                                    if 'admin' in prms:
                                                        admin = prms['admin']
                                                    sfw = True
                                                    if 'nsfw' in prms:
                                                        sfw = not prms['nsfw']
                                                    desc = None
                                                    if 'description' in cmd:
                                                        desc = cmd['description']
                                                    usage = f'>>{cmd["name"]}'
                                                    if 'usage' in cmd:
                                                        usage = cmd['usage']
                                                        usage = usage.replace('{pfx}', '>>')
                                                        usage = usage.replace('{cmd}', cmd['name'])
                                                    names = {
                                                        'primary': cmd['name']
                                                    }
                                                    alts = None
                                                    if 'alts' in cmd:
                                                        alts = cmd['alts']
                                                    names.update({'alts': alts})
                                                    cmd_data = {
                                                        'admin': admin,
                                                        'category': category.lower(),
                                                        'desc': desc,
                                                        'names': names,
                                                        'partner': partner,
                                                        'sfw': sfw,
                                                        'usage': usage
                                                    }
                                                    if category.lower() in modules_temp:
                                                        mtmp = modules_temp[category.lower()]
                                                        mtmp.append(cmd_data)
                                                    else:
                                                        mtmp = [cmd_data]
                                                    modules_temp.update({category.lower(): mtmp})
                for mkey in modules_temp:
                    commands = modules_temp[mkey]
                    commands = sorted(commands, key=lambda c: c['names']['primary'])
                    icon = self.icons[mkey]
                    if mkey == 'nsfw':
                        name = mkey.upper()
                    else:
                        name = mkey.title().replace('_', ' ')
                    mdl_data = {
                        'name': name,
                        'icon': icon,
                        'commands': commands
                    }
                    self.modules.append(mdl_data)
                self.modules = sorted(self.modules, key=lambda k: k['name'])
                self.cache_stamp = arrow.utcnow().float_timestamp
            return self.modules

        def get(self):
            data = self.load_commands()
            return data

    return CommandsEndpoint, location
