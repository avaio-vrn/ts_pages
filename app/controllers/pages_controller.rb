# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_filter :find_record
  before_filter :set_actions, if: proc { request.format.symbol == :html && current_user&.admin_less? }

  def show
    @title = @page.content_header
    render 'simple_show'
  end

  private

  def find_record
    @page = ::Page.where(id_str: params[:id]).first
    raise ActiveRecord::RecordNotFound if @page.blank?
  end

  def set_actions
    @admin_panel = ::Admin::Panel::Base.new(@page || ::Page)
    @admin_panel.from(controller_name, action_name)
  end
end
