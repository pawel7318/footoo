Warden.test_mode!

def login_and_switch_schema(user)
 login_as(user)
 Apartment::Database.switch(user.username) 
end

def destroy_users_schema(user)
  Apartment::Database.drop(user.username)
  Apartment::Database.reset
end

def destroy_user(user)
  User.destroy(user)
end
