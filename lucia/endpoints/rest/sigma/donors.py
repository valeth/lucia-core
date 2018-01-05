import os

import yaml
from flask_restful import Resource


def load_rest_endpoint(core):
    location = '/rest/sigma/donors'

    class SigmaDonors(Resource):
        def __init__(self):
            self.core = core

        def get(self):
            if core.cfg.app.sigma:
                donor_path = f'{core.cfg.app.sigma}/info/donors.yml'
                if os.path.exists(donor_path):
                    with open(donor_path, encoding='utf-8') as donor_file:
                        donors = yaml.safe_load(donor_file)
                    new_list = []
                    for donor in donors['donors']:
                        user_data = self.core.db.aurora.UserDetails.find_one({'UserID': donor['duid']})
                        if user_data:
                            donor.update({'name': user_data['Name']})
                            donor.update({'avatar': user_data['Avatar']})
                        new_list.append(donor)
                    donors = {'donors': sorted(new_list, key=lambda x: x['tier'], reverse=True)}
                else:
                    donors = {'error': 'Donor file not found.'}
            else:
                donors = {'error': 'Sigma location not set.'}
            return donors

    return SigmaDonors, location
