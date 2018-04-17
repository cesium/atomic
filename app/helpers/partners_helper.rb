module PartnersHelper
  def can_create?
    can? :create, Partner
  end

  def error_messages(partner)
    partner.errors.full_messages
  end
end