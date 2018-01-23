from flask_restful import Resource
from lucia.core.utils.details import get_user
from lucia.core.utils.creators import make_usr_def_data, make_compat_data


def load_rest_endpoint(core):
    location = '/rest/sigma/leaderboard/<string:board>'

    class SigmaLeaderboard(Resource):
        def __init__(self):
            self.core = core

        def get(self, board):
            if board == 'currency':
                collection = 'CurrencySystem'
                sort_key = 'global'
            elif board == 'experience':
                collection = 'ExperienceSystem'
                sort_key = 'global'
            elif board == 'cookies':
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
                    user_data = get_user(self.core.cfg.app.token, uid)
                    if user_data:
                        user_data = make_compat_data(user_data)
                    else:
                        user_data = make_usr_def_data(uid)
                    outlist.append({'user': user_data, 'value': doc.get(sort_key)})
                out_data = {'leaderboard': outlist}
            else:
                out_data = {'error': 'Unrecognized type.'}
            return out_data

    return SigmaLeaderboard, location
