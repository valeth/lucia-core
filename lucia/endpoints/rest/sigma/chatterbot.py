from flask import request
from chatterbot import ChatBot
from flask_restful import Resource


def load_rest_endpoint(core):
    location = '/rest/sigma/chatterbot'

    class SigmaChatterbot(Resource):
        def __init__(self):
            self.core = core
            self.cb = ChatBot(
                "Sigma",
                database='chatterbot',
                database_uri=core.db.db_address,
                storage_adapter='chatterbot.storage.MongoDatabaseAdapter'
            )

        def post(self):
            req_data = request.get_json()
            if req_data:
                interaction = req_data.get('interaction')
                if interaction:
                    response = self.cb.get_response(interaction)
                    data = {'response': str(response)}
                else:
                    data = {'error': 'No interaction data.'}
            else:
                data = {'error': 'No request data.'}
            return data

    return SigmaChatterbot, location
