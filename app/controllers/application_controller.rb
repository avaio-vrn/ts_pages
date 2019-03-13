# -*- encoding : utf-8 -*-
class ApplicationController < TemplateSystemController
  before_filter :get_main_instance

  private

  def get_main_instance
    @menu_pages = { sections: Section.where(in_menu: true, parent_id: nil).not_deleted.ordering }
    @menu_pages.merge!(pages: Page.where('id_str != ?', "home_index_page").where(in_menu: true).not_deleted.ordering)
    @biz_info = BizInfo.new
    @temsys_theme = TemplateSystemLayout::Theme.new(action_name, request.original_fullpath)
  end
end

