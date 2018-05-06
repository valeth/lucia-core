from chatterbot import ChatBot
from flask import request
from flask_restful import Resource

cb_cache = None
inter_cache = {}


def get_cb(core):
    global cb_cache
    if not cb_cache:
        cb_cache = ChatBot(
            "Sigma",
            database='chatterbot',
            read_only=True,
            database_uri=core.db.db_address,
            storage_adapter='chatterbot.storage.MongoDatabaseAdapter',
            output_format='text'
        )
    return cb_cache


def load_rest_endpoint(core):
    location = '/rest/sigma/chatterbot'

    class SigmaChatterbot(Resource):
        def __init__(self):
            self.core = core
            self.cache = {}

        @staticmethod
        def post():
            cb = get_cb(core)
            req_data = request.get_json()
            if req_data:
                interaction = req_data.get('interaction')
                conversation = req_data.get('conversation')
                if interaction and conversation:
                    interaction = cb.input.process_input_statement(interaction)
                    response = inter_cache.get(interaction.text)
                    if not response:
                        _, response = cb.generate_response(interaction, conversation)
                        cb.output.process_response(response)
                        inter_cache.update({interaction.text: response})
                    data = {'response': response.text}
                else:
                    data = {'error': 'Missing data arguments.'}
            else:
                data = {'error': 'No request data.'}
            return data

    return SigmaChatterbot, location
