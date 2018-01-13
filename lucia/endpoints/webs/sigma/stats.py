import json
from flask_socketio import Namespace, emit


def load_webs_endpoint(core):
    location = '/webs/sigma/stats'

    class SigmaStatistics(Namespace):
        def __init__(self, namespace):
            super().__init__(namespace)
            self.core = core

        def get_command_stats(self):
            out_data = {}
            total_count = 0
            command_docs = self.core.db.aurora.CommandStats.find({})
            for command_doc in command_docs:
                command_name = command_doc.get('command')
                command_count = command_doc.get('count')
                out_data.update({command_name: command_count})
                total_count += command_count
            return total_count, out_data

        def get_event_stats(self):
            out_data = {}
            event_docs = self.core.db.aurora.EventStats.find({})
            for event_doc in event_docs:
                event_name = event_doc.get('event')
                event_count = event_doc.get('count')
                out_data.update({event_name: event_count})
            return out_data

        def get_population_stats(self):
            population_doc = self.core.db.aurora.GeneralStats.find_one({'name': 'population'})
            if population_doc:
                del population_doc['_id']
                del population_doc['name']
            else:
                population_doc = {}
            return population_doc

        def get_special_stats(self):
            out_data = {}
            special_docs = self.core.db.aurora.SpecialStats.find({})
            for special_doc in special_docs:
                stat_name = special_doc.get('name')
                stat_count = special_doc.get('count')
                out_data.update({stat_name: stat_count})
            return out_data

        def on_get_stats(self, data):
            if data.get('stat') == 'all':
                event_stats = self.get_event_stats()
                command_count, command_stats = self.get_command_stats()
                population_stats = self.get_population_stats()
                special_stats = self.get_special_stats()
                out_data = {
                    'commands': command_stats,
                    'events': event_stats,
                    'general': {
                        'population': population_stats,
                        'cmd_count': command_count
                    },
                    'special': special_stats
                }
            else:
                lookup = self.core.db.aurora.CommandStats.find({'command': data.get('stat')})
                if not lookup:
                    out_data = {'error': 'Statistic not found.'}
                else:
                    del lookup['_id']
                    out_data = lookup
            out_data = json.dumps(out_data)
            emit('sigma_stats', out_data)

    return SigmaStatistics, location
