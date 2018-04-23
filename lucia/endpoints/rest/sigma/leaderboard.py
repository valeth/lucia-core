from flask_restful import Resource

from lucia.core.utils.creators import make_usr_def_data, make_compat_data
from lucia.core.utils.details import get_user


def load_rest_endpoint(core):
    location = '/rest/sigma/leaderboard/<string:board>'

    class SigmaLeaderboard(Resource):
        def __init__(self):
            self.core = core
            self.board_data = {
                'currency': {
                    'coll': 'CurrencySystem',
                    'sort': 'global',
                    'names': {
                        'pre': [
                            'Regular', 'Iron', 'Bronze', 'Silver', 'Gold',
                            'Platinum', 'Diamond', 'Opal', 'Sapphire', 'Musgravite'
                        ],
                        'suf': [
                            'Pickpocket', 'Worker', 'Professional', 'Collector', 'Capitalist',
                            'Entrepreneur', 'Executive', 'Banker', 'Royal', 'Illuminati'
                        ]
                    },
                    'leveler': 1133.55
                },
                'experience': {
                    'coll': 'ExperienceSystem',
                    'sort': 'global',
                    'names': {
                        'pre': [
                            'Hiding', 'Silent', 'Whispering', 'Chatty', 'Talkative',
                            'Loud', 'Yelling', 'Supersonic', 'Worldwide', 'Galactic'
                        ],
                        'suf': [
                            'Ghost', 'Shadow', 'Lurker', 'Ninja', 'Person',
                            'Loudmouth', 'Drill Sergeant', 'Announcer', 'Mother', 'Jet Engine'
                        ]
                    },
                    'leveler': 13266.85
                },
                'cookies': {
                    'coll': 'Cookies',
                    'sort': 'Cookies',
                    'names': {
                        'pre': [
                            'Starving', 'Picky', 'Nibbling', 'Munching', 'Noming',
                            'Glomping', 'Chomping', 'Inhaling', 'Gobbling', 'Devouring'
                        ],
                        'suf': [
                            'Licker', 'Taster', 'Eater', 'Chef', 'Connoisseur',
                            'Gorger', 'Epicure', 'Glutton', 'Devourer', 'Void'
                        ]
                    },
                    'leveler': 5.15
                }
            }

        @staticmethod
        def get_title(level: int, prefixes: list, suffixes: list):
            title_tier = level // 100
            loop_index = 0
            out_title = None
            while not out_title:
                for prefix in prefixes:
                    if not out_title:
                        for suffix in suffixes:
                            if loop_index == level:
                                out_title = f'{prefix} {suffix}'
                                break
                            loop_index += 1
            return title_tier, out_title

        def get(self, board):
            board_data = self.board_data.get(board) or {}
            collection = board_data.get('coll')
            sort_key = board_data.get('sort')
            if collection and sort_key:
                title_pieces = board_data.get('names')
                prefixes = title_pieces.get('pre')
                suffixes = title_pieces.get('suf')
                leveler = board_data.get('leveler')
                all_docs = self.core.db.aurora[collection].find({}).sort(sort_key, -1).limit(20)
                outlist = []
                for doc in all_docs:
                    uid = doc.get('UserID')
                    user_data = get_user(self.core.cfg.app.token, uid)
                    if user_data:
                        user_data = make_compat_data(user_data)
                    else:
                        user_data = make_usr_def_data(uid)
                    value = doc.get(sort_key)
                    curr_level = int(value / leveler)
                    next_level_req = int((curr_level + 1) * leveler)
                    next_level_perc = round((value / next_level_req) * 100, 2)
                    tier, title = self.get_title(curr_level, prefixes, suffixes)
                    outlist.append(
                        {
                            'user': user_data,
                            'value': value,
                            'level': {
                                'curr': curr_level,
                                'next_req': next_level_req,
                                'next_perc': next_level_perc
                            },
                            'title': {
                                'tier': tier,
                                'name': title
                            }
                        }
                    )
                out_data = {'leaderboard': outlist}
            else:
                out_data = {'error': 'Unrecognized type.'}
            return out_data

    return SigmaLeaderboard, location
