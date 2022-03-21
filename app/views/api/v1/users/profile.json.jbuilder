# frozen_string_literal: true

json.data do
  json.extract! @current_user, :id, :username, :email, :phone, :first_name, :last_name, :display_name, :admin
end
