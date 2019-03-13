class SectionsController < ApplicationController
  before_filter :find_record
  before_filter :set_actions, if: proc { current_user&.admin_less? }

  def show
    @title = @section.content_header
    render 'simple_show'
  end

  private

  def find_record
    @section = ::Section.where(id_str: params[:id]).first
    raise ActiveRecord::RecordNotFound if @section.blank?
  end

  def set_actions
    @admin_panel = Admin::Panel::Base.new(@section || ::Section)
    @admin_panel.from(controller_name, action_name)
    @parent_id = params[:parent_id]
  end
end
