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
                read_only=True,
                database_uri=core.db.db_address,
                storage_adapter='chatterbot.storage.MongoDatabaseAdapter',
                output_format='text'
            )

        def post(self):
            req_data = request.get_json()
            if req_data:
                interaction = req_data.get('interaction')
                conversation = req_data.get('conversation')
                if interaction and conversation:
                    interaction = self.cb.input.process_input_statement(interaction)
                    _, response = self.cb.generate_response(interaction, conversation)
                    self.cb.output.process_response(response)
                    data = {'response': str(response)}
                else:
                    data = {'error': 'Missing data arguments.'}
            else:
                data = {'error': 'No request data.'}
            return data

    return SigmaChatterbot, location
