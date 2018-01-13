import json
from flask_socketio import Namespace, emit
from lucia.core.utils.creators import make_usr_def_data


def load_webs_endpoint(core):
    location = '/webs/sigma/leaderboard'

    class SigmaLeaderboard(Namespace):
        def __init__(self, namespace):
            super().__init__(namespace)
            self.core = core

        def on_get_board(self, data):
            if data.get('type') == 'currency':
                collection = 'CurrencySystem'
                sort_key = 'global'
            elif data.get('type') == 'experience':
                collection = 'ExperienceSystem'
                sort_key = 'global'
            elif data.get('type') == 'cookies':
                collection = 'Cookies'
                sort_key = 'Cookies'
            else:
                collection = None
                sort_key = None
            if collection and sort_key:
                all_docs = self.core.db.aurora[collection].find({}).sort(sort_key, -1).limit(20)
                outlist = []
                for doc in all_docs:
                    uid = doc.get('UserID')
                    user_data = self.core.db.aurora.UserDetails.find_one({'UserID': uid})
                    if user_data:
                        del user_data['_id']
                    else:
                        user_data = make_usr_def_data(uid)
                    outlist.append({'user': user_data, 'value': doc.get(sort_key)})
                out_data = {'leaderboard': outlist}
            else:
                out_data = {'error': 'Unrecognized type.'}
            out_data = json.dumps(out_data)
            emit('leaderboard_push', out_data)

    return SigmaLeaderboard, location
