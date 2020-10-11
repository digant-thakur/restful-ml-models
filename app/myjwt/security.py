from users import User

users = [User(1, 'user', 'pass')]
username_mapping = {u.username: u for u in users}
userid_mapping = {u.id: u for u in users}

def authenticate(username, password):
    user = username_mapping.get(username, None)
    if user and password == user.password:
        return user
    return None

def identity(payload):
    user_id = payload['identity']
    return userid_mapping.get(user_id, None)