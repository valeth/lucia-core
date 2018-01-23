import arrow
import time
import requests

guild_cache = {}


def get_user(token, user_id):
    cached_user = guild_cache.get(user_id)
    need_fresh = True
    if cached_user:
        if cached_user.get('stamp') + 3600 < arrow.utcnow().float_timestamp:
            need_fresh = False
    if need_fresh:
        time.sleep(1)
        headers = {'Authorization': f'Bot {token}'}
        user_data_url = f'https://discordapp.com/api/users/{user_id}'
        user_data_req = requests.get(user_data_url, headers=headers)
        if user_data_req.ok:
            user_data = user_data_req.json()
        else:
            user_data = None
        cache_data = {'user': user_data, 'stamp': arrow.utcnow().float_timestamp}
        guild_cache.update({user_id: cache_data})
    return guild_cache.get(user_id)