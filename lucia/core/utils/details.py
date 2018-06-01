import time

import arrow
import requests


def get_user(db, token, user_id):
    lookup = {'UserID': user_id}
    cached_user = db.lucia.UserCache.find_one(lookup)
    if cached_user:
        if cached_user.get('Time') + 86400 < arrow.utcnow().timestamp:
            need_fresh = True
        else:
            need_fresh = False
    else:
        need_fresh = True
    if need_fresh:
        time.sleep(1)
        headers = {'Authorization': f'Bot {token}'}
        user_data_url = f'https://discordapp.com/api/users/{user_id}'
        user_data_req = requests.get(user_data_url, headers=headers)
        if user_data_req.ok:
            user_data = user_data_req.json()
        else:
            user_data = None
        cache_data = {'UserID': user_id, 'Data': user_data, 'Time': arrow.utcnow().timestamp}
        if cached_user is None:
            db.lucia.UserCache.insert_one(cache_data)
        else:
            db.lucia.UserCache.update_one(lookup, {'$set': cache_data})
    else:
        user_data = cached_user.get('Data')
    return user_data
