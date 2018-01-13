def make_usr_def_data(uid):
    unknown_user_data = {
        'Name': '{Unknown}',
        'Nickname': '{Unknown}',
        'Discriminator': None,
        'UserID': uid,
        'Avatar': 'https://i.imgur.com/QnYSlld.png',
        'Color': '#000000'
    }
    return unknown_user_data


def make_srv_def_data(sid):
    unknown_server_data = {
        'Name': '{Unknown}',
        'ServerID': sid,
        'Icon': 'https://i.imgur.com/QnYSlld.png'
    }
    return unknown_server_data
