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

class PageSection < TemplateSystem::Record::Base
  ROW_NUM_FIELDS = [:section_id].freeze

  belongs_to :section

  attr_accessible :content_header, :content_name, :section_id, :in_menu

  validates_presence_of :content_name
  validate :uniqueness_content_name

  def to_s
    content_header.blank? ? content_name || "" : content_header
  end

  def self.form_danger_options
    []
    # [{ field: :section_id, field_type: :collection_select,
    #    collection: Section.ordering, value_method: :id, text_method: :content_name,
    #    field_css_class: "f-a-input" }]
  end

  def invert_obj
    ['admin', self.section, self]
  end

  private

  def uniqueness_content_name
    unless PageSection.where(section_id: section_id, content_name: content_name).where("id <> ?", id).blank?
      errors.add :content_name
    end
  end
end
