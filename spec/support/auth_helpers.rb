
def login_and_switch_schema(user) 
 Warden.test_mode!
 login_as(user, scope: :user)

 Apartment::Tenant.switch(user.username) 
end

def sign_in_and_switch_schema(user) 
 @request.env["devise.mapping"] = Devise.mappings[:user]
 sign_in :user, user
 #login_as(user, scope: :user)

 Apartment::Tenant.switch(user.username) 
end

def destroy_users_schema(user)
  Apartment::Tenant.drop(user.username)
  Apartment::Tenant.reset
end

def destroy_user(user)
  User.destroy(user)
end
