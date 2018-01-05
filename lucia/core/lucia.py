import arrow
import flask
import flask_restful
import flask_socketio
import flask_cors

from lucia.core.nodes.config import Configuration
from lucia.core.nodes.database import Database
from lucia.core.nodes.loader import EndpointLoader


class LuciaCore(flask.Flask):
    def __init__(self):
        super().__init__(__name__)
        self.start = arrow.utcnow()
        self.cfg = Configuration()
        self.db = Database(self)
        # noinspection PyTypeChecker
        self.rest = flask_restful.Api(self)
        self.webs = flask_socketio.SocketIO(self)
        self.loader = EndpointLoader(self)

    def run(self, *args):
        print('--------------------------------')
        print('Starting Up Lucia\'s Endpoint!')
        print('--------------------------------')
        flask_cors.CORS(self, origins=self.cfg.app.cors)
        super().run(self.cfg.app.host, self.cfg.app.port, self.cfg.app.debug)
