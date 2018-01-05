import pymongo


class Database(pymongo.MongoClient):
    def __init__(self, core):
        self.core = core
        self.db_cfg = self.core.cfg.db
        if self.db_cfg.auth:
            self.db_address = f'mongodb://{self.db_cfg.user}:{self.db_cfg.pasw}'
            self.db_address += f'@{self.db_cfg.host}:{self.db_cfg.port}/'
        else:
            self.db_address = f'mongodb://{self.db_cfg.host}:{self.db_cfg.port}/'
        super().__init__(self.db_address)
