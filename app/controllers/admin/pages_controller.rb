# -*- encoding : utf-8 -*-
class Admin::PagesController < ApplicationController
  authorize_resource

  before_filter :find_record, only: [:show, :edit, :update, :destroy]
  before_filter :check_row_num, only: :index
  before_filter :set_actions, if: proc { request.format.symbol == :html && current_user&.admin_less? }

  def index
    list = ::Page.ordering
    @list_pages = Admin::ListPages.new do |l|
      l.controller_name = controller_name
      l.action_name = action_name
      l.list = defined?(TsEshop) ? list.page(params[:page]) : list
    end
    render 'admin_index'
  end

  def show
    redirect_to page_url(@page)
  end

  def new
    @obj = ::Page.new(in_menu: true)
    @obj.build_image
    render 'new_edit'
  end

  def edit
    @obj = @page
    @obj.build_image if @obj.image.blank?
    render 'new_edit'
  end

  def create
    @page = ::Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to  @page, notice: view_context.h_flash_msg(:create, 'page'.freeze) }
      else
        format.html { render action: 'new', template: '/application/new_edit'}
      end
    end
  end

  def update
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, notice: view_context.h_flash_msg(:update, 'page'.freeze) }
      else
        format.html { render action: 'edit', template: '/application/new_edit' }
      end
    end
  end

  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: view_context.h_flash_msg(:destroye, 'page'.freeze) }
      format.json { render json: @page }
    end
  end

  private

  def find_record
    @page = ::Page.where(id_str: params[:id]).first
  end

  def check_row_num
    row_num_record = Admin::RowNum::Fix.new(:page)
    if !params[:cancel_check_row_num] && row_num_record.need_check?
      redirect_to template_system.admin_edit_fix_row_num_url(:page, { model_namespace: 'admin' })
    end
  end

  def set_actions
    @admin_panel = ::Admin::Panel::Base.new(@page || ::Page)
    @admin_panel.from(controller_name, action_name)
  end
end
