# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "nishant"
  user.email                 "samnish1@umbc.edu"
  user.password              "nishant"
  user.password_confirmation "nishant"
end
