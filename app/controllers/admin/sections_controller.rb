class Admin::SectionsController < ApplicationController
  authorize_resource

  before_filter :find_record, only: [:show, :edit, :update, :destroy]
  before_filter :check_row_num, only: :index, if: proc { current_user && current_user.admin_less? }
  before_filter :set_actions, if: proc { request.format.symbol == :html && current_user&.admin_less? }

  def index
    if current_user && current_user.admin_less? && admin_view?
        list = Section.where(parent_id: params[:parent_id]).ordering
      @list_pages = Admin::ListPages.new do |l|
        l.controller_name = controller_name
        l.action_name = action_name
        l.list = defined?(TsEshop) ? list.page(params[:page]) : list
      end
      render 'admin_index'
    else
      redirect_to root_path
    end
  end

  def show
    redirect_to section_url(@section)
  end

  def new
    @section = Section.new(parent_id: params[:parent_id], in_menu: true)
    @section.build_image
    render "new_edit"
  end

  def edit
    @section.build_image if @section.image.blank?
    render "new_edit"
  end

  def create
    @section = ::Section.new(params[:section])

    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: view_context.h_flash_msg(:create, 'section'.freeze) }
      else
        format.html { render action: "new", template: "new_edit" }
      end
    end
  end

  def update
    respond_to do |format|
      if @section.update_attributes(params[:section])
        format.html { redirect_to @section, notice: view_context.h_flash_msg(:update, 'section'.freeze) }
      else
        format.html { render action: "edit", template: "new_edit" }
      end
    end
  end

  def destroy
    @section.destroy

    respond_to do |format|
      format.html {redirect_to root_url, notice: view_context.h_flash_msg(:destroye, 'section'.freeze)}
      format.json { render json: @section }
    end
  end

  private

  def find_record
    @section = ::Section.where(id_str: params[:id]).first
  end

  def check_row_num
    row_num_record = Admin::RowNum::Fix.new(:section, nil, parent_id: params[:parent_id] || 'NULL')
    if !params[:cancel_check_row_num] && row_num_record.need_check?
      redirect_to template_system.admin_edit_fix_row_num_url(:section, model_namespace: 'admin', opt: { parent_id: params[:parent_id] || 'NULL' })
    end
  end

  def set_actions
    @admin_panel = Admin::Panel::Base.new(@section || ::Section)
    @admin_panel.from(controller_name, action_name)
    @parent_id = params[:parent_id]
  end
end
