class BaseController < ApplicationController
  def home
    @page = Page.where(id_str: :home_index_page).first
    @base = @page

    if current_user&.admin_less?
      @admin_panel = Admin::Panel::Base.new(@page)
      @admin_panel.from(controller_name, action_name)
    end

    render 'simple_show'
  end
end
