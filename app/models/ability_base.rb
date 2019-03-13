# -*- encoding : utf-8 -*-
class AbilityBase
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
      can :del, :all
    elsif user.admin_less?
      can :read, :all
      can :del, :all
      can :update, :all
      cannot :destroy, :all
    else
      can :read, :all
      can [:order, :send_order], Page

		  cannot :index, Page
      cannot :index, [Admin::TemplateSystem::PersistentData]
      cannot :read, [User, TemplateSystem::Template, TemplateSystem::TemplateType, Seo::MetaTag,
                     TemplateSystem::TemplateContent, TemplateSystem::TemplateTableContent]
    end
  end
end
