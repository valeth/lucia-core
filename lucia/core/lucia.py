import asyncio
from concurrent.futures import ThreadPoolExecutor

import arrow
import discord
import flask
# import flask_socketio
import flask_cors
import flask_restful
# import flask_socketio

from lucia.core.nodes.config import Configuration
from lucia.core.nodes.database import Database
from lucia.core.nodes.loader import EndpointLoader


class LuciaCore(object):
    def __init__(self):
        self.flask = flask.Flask(__name__)
        self.start = arrow.utcnow()
        self.cfg = Configuration()
        self.db = Database(self)
        self.bot = discord.Client()
        self.loop = asyncio.get_event_loop()
        # noinspection PyTypeChecker
        self.rest = flask_restful.Api(self.flask)
        # self.webs = flask_socketio.SocketIO(self.flask)
        self.loader = EndpointLoader(self)

    def run(self):
        print('--------------------------------')
        print('Starting Up Lucia\'s Endpoint!')
        print('--------------------------------')
        flask_cors.CORS(self.flask, origins=self.cfg.app.cors)
        self.loop.run_in_executor(ThreadPoolExecutor(), self.bot.start(self.cfg.app.token))
        self.flask.run(self.cfg.app.host, self.cfg.app.port, debug=self.cfg.app.debug)
