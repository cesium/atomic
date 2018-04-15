class Registration < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  def toggle_confirmation(old_value)
    if ActiveModel::Type::Boolean.new.cast(old_value)
      update_attribute(:confirmed, false)
      [:alert, "Confirmação de #{user.name} cancelada!"]
    else
      update_attribute(:confirmed, true)
      [:success, "#{user.name} confirmado!"]
    end
  end
end
