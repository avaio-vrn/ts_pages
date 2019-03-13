class PageSectionsController < ApplicationController
  before_filter :find_record
  before_filter :set_actions, if: proc { request.format.symbol == :html && current_user&.admin_less? }

  def show
    @title = @page_section.content_header
    render 'simple_show'
  end

  private

  def find_record
    @page_section = ::PageSection.where(id_str: params[:id]).first
    raise ActiveRecord::RecordNotFound if @page_section.blank?
  end

  def set_actions
    @section = ::Section.where(id_str: params[:section_id]).first
    @admin_panel = ::Admin::Panel::Base.new([@section, @page_section || ::PageSection])
    @admin_panel.from(controller_name, action_name)
  end
end
