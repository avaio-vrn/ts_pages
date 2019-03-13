# -*- encoding : utf-8 -*-
class Admin::PageSectionsController < ApplicationController
  authorize_resource

  before_filter :find_records, only: :index
  before_filter :find_record, only: [:show, :new, :edit, :update, :destroy]
  before_filter :check_row_num, only: :index
  before_filter :set_actions, if: proc { request.format.symbol == :html && current_user&.admin_less? }

  def index
    list = @page_sections.ordering
    @list_pages = Admin::ListPages.new do |l|
      l.controller_name = controller_name
      l.action_name = action_name
      l.list = defined?(TsEshop) ? list.page(params[:page]) : list
    end
    render 'admin_index'
  end

  def show
    redirect_to section_page_section_url(@section, @page_section)
  end

  def new
    section = ::Section.where(id_str: params[:section_id]).first
    params[:section_id] = section.id
    page_section = ::PageSection.new(section_id:  params[:section_id], in_menu: true)
    @obj = page_section.invert_obj
    page_section.build_image
    render 'new_edit'
  end

  def edit
    @obj = @page_section.invert_obj
    @page_section.build_image if @page_section.image.blank?
    render 'new_edit'
  end

  def create
    @page_section = ::PageSection.new(params[:page_section])

    respond_to do |format|
      if @page_section.save
        format.html { redirect_to [@page_section.section, @page_section], notice: view_context.h_flash_msg(:create, 'page_section'.freeze) }
      else
        format.html { render action: 'new', template: '/application/new_edit'}
      end
    end
  end

  def update
    respond_to do |format|
      if @page_section.update_attributes(params[:page_section])
        format.html { redirect_to [@section, @page_section], notice: view_context.h_flash_msg(:update, 'page_section'.freeze) }
      else
        format.html { render action: 'edit', template: '/application/new_edit' }
      end
    end
  end

  def destroy
    @page_section.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: view_context.h_flash_msg(:destroye, 'page_section'.freeze) }
      format.json { render json: @page_section }
    end
  end

  private

  def find_records
    @section = ::Section.includes(:page_sections).where(id_str: params[:section_id]).first
    @page_sections = @section.page_sections
  end

  def find_record
    @section = ::Section.where(id_str: params[:section_id]).first
    @page_section = ::PageSection.where(id_str: params[:id]).first
  end

  def check_row_num
    contentable_params = { section_id: params[:section_id] }
    row_num_record = Admin::RowNum::Fix.new(:page_section, nil, contentable_params)
    if !params[:cancel_check_row_num] && row_num_record.need_check?
      redirect_to template_system.admin_edit_fix_row_num_url(:page_section, model_namespace: 'admin', opt: contentable_params)
    end
  end

  def set_actions
    @admin_panel = ::Admin::Panel::Base.new([@section, @page_section || ::PageSection])
    @admin_panel.from(controller_name, action_name)
  end
end
