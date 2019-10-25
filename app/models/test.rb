class Test < ApplicationRecord
   validates :name, presence: true, allow_blank: false
   validates_uniqueness_of :name

   belongs_to :app_tag, class_name: "Tag", foreign_key: "app_tag_id", optional: true
   belongs_to :feature_tag, class_name: "Tag", foreign_key: "feature_tag_id", optional: true
   belongs_to :owner_tag, class_name: "Tag", foreign_key: "owner_tag_id", optional: true
   
   has_one :dev_build, -> {where env: 'dev'}, class_name: 'Build'
   has_one :qa_build, -> {where env: 'qa'}, class_name: 'Build'
   has_one :prod_build, -> {where env: 'prod'}, class_name: 'Build'

   #static variables
   ##########################################################################################################
   def self.build(env_tag)
      if env_tag.name == 'dev'
         dev_build
      elsif env_tag.name == 'qa'
         qa_build
      else
         prod_build
      end
   end
end
