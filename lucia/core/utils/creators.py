def make_usr_def_data(uid):
    unknown_user_data = {
        'Name': '{Unknown}',
        'Discriminator': None,
        'UserID': uid,
        'Avatar': 'https://i.imgur.com/QnYSlld.png'
    }
    return unknown_user_data


def make_compat_data(data):
    data = data.get('user')
    user_id = data.get('id')
    avatar_id = data.get('avatar')
    avatar_url = 'https://i.imgur.com/QnYSlld.png'
    if avatar_id:
        if avatar_id.startswith('a_'):
            avatar_url = f'https://cdn.discordapp.com/avatars/{user_id}/{avatar_id}.gif'
        else:
            avatar_url = f'https://cdn.discordapp.com/avatars/{user_id}/{avatar_id}.png'
    user_data = {
        'Name': data.get('username'),
        'Discriminator': data.get('discriminator'),
        'UserID': user_id,
        'Avatar': avatar_url
    }
    return user_data


def make_srv_def_data(sid):
    unknown_server_data = {
        'Name': '{Unknown}',
        'ServerID': sid,
        'Icon': 'https://i.imgur.com/QnYSlld.png'
    }
    return unknown_server_data
