class Tag < ApplicationRecord
   validates_uniqueness_of :name
   validates :name, presence: true, allow_blank: false
   has_many :app_tests, class_name: "Test", foreign_key: "app_tag_id"
   has_many :feature_tests, class_name: "Test", foreign_key: "feature_tag_id"
   has_many :owner_tests, class_name: "Test", foreign_key: "owner_tag_id"

   has_many :app_dev_builds, :through => :app_tests, source: :dev_build
   has_many :app_qa_builds, :through => :app_tests, source: :qa_build
   has_many :app_prod_builds, :through => :app_tests, source: :prod_build

   has_many :feature_dev_builds, :through => :feature_tests, source: :dev_build
   has_many :feature_qa_builds, :through => :feature_tests, source: :qa_build
   has_many :feature_prod_builds, :through => :feature_tests, source: :prod_build

   has_many :owner_dev_builds, :through => :owner_tests, source: :dev_build
   has_many :owner_qa_builds, :through => :owner_tests, source: :qa_build
   has_many :owner_prod_builds, :through => :owner_tests, source: :prod_build

   def self.find_by_name(app_name)
      exists?(name: app_name) ? where(name: app_name).first : create(name: app_name)
   end

   #In test index #################################################################
   def self.all_as_json(tag_type)
      where(tag_type: tag_type).order(:tag_type, :name).as_json(only: [:id, :name, :tag_type])
   end
   def self.get_edit_json_test(tag_type)
      where(tag_type: tag_type).order(:tag_type, :name).as_json(only: [:id, :name, :tag_type])
   end
   ################################################################################

   def self.edit_all_as_json
      all.includes(:app_tests, :owner_tests, :feature_tests).order(:tag_type, :name).as_json(only: [:id, :name, :tag_type], include: { app_tests: { only: [:name, :id] }, feature_tests: { only: [:name, :id] }, owner_tests: { only: [:name, :id] } })
   end

   def edit_as_json
      as_json(only: [:name, :id, :tag_type], include: { app_tests: { only: [:name, :id] },feature_tests: { only: [:name, :id] }, owner_tests: { only: [:name, :id] } })
   end

   def self.select_options(tag_type)
      where(tag_type: tag_type).map{ |tag| [tag.name, tag.id] } << ["None", 0]
   end
end
