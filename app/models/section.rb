# == Schema Information
#
# Table name: sections
#
#  id             :integer          not null, primary key
#  content_name   :string(255)
#  content_header :string(255)
#  row_num        :integer
#  del            :boolean          default(FALSE)
#  id_str         :string(70)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Section < TemplateSystem::Record::Base
  belongs_to :parent, class_name: '::Section'
  has_many :child_sections, class_name: '::Section', foreign_key: "parent_id", dependent: :destroy
  has_many :page_sections, dependent: :destroy

  attr_accessible :content_header, :content_name, :in_menu, :parent_id

  def to_s
    content_name
  end

  def invert_obj
    ['admin', self]
  end
end
