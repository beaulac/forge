Factory.define :user do |user|
  user.email                  "user@example.com"
  user.password               "password"
  user.password_confirmation  "password"
end

Factory.define(:admin, :class => User) do |user|
  user.email                  "user@example.com"
  user.password               "password"
  user.password_confirmation  "password"
  user.roles                  { |u| [u.association(:admin_role)] }
end

Factory.define(:admin_role, :class => Role) do |role|
  role.title "Admin"
end