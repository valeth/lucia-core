import asyncio

import arrow
import flask
import flask_restful
import flask_socketio

from lucia.core.nodes.config import Configuration
from lucia.core.nodes.database import Database
from lucia.core.nodes.loader import EndpointLoader


class LuciaCore(flask.Flask):
    def __init__(self):
        super().__init__(__name__)
        self.start = arrow.utcnow()
        self.cfg = Configuration()
        self.db = Database(self)
        self.loop = asyncio.get_event_loop()
        # noinspection PyTypeChecker
        self.rest = flask_restful.Api(self)
        self.webs = flask_socketio.SocketIO(self)
        self.loader = EndpointLoader(self)
        self.clean_user_cache()

    def clean_user_cache(self):
        self.db.lucia.UserCache.delete_many({'Time': {'$lt': arrow.utcnow().timestamp - 86400}})

    def run(self, *args):
        print('--------------------------------')
        print('Starting Up Lucia\'s Endpoint!')
        print('--------------------------------')
        super().run(self.cfg.app.host, self.cfg.app.port, debug=self.cfg.app.debug)
