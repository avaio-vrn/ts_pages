# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: pages
#
#  id             :integer          not null, primary key
#  content_name   :string(255)
#  content_header :string(255)
#  section_id     :integer
#  row_num        :integer
#  id_str         :string(255)      not null
#  del            :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Page < TemplateSystem::Record::Base
  attr_accessible :content_header, :content_name, :in_menu
  attr_accessor :section_id

  validates_presence_of :content_name
  validates_uniqueness_of :content_name

  def to_s
    content_header.blank? ? content_name || "" : content_header
  end

  def invert_obj
    ['admin', self]
  end

  def self.form_danger_options
    []
    # [{ field: :section_id, field_type: :collection_select,
    #    collection: Section.ordering, value_method: :id, text_method: :content_name,
    #    field_css_class: "f-a-input" }]
  end
end
