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


   #instance methods
   ##########################################################################################################
   def get_edit_json
      self.as_json(only: [:name, :id, :parameterized, :job_url], include: { app_tag: { only: [:name, :id] },feature_tag: { only: [:name, :id] },owner_tag: { only: [:name, :id] } })
   end
   #in update in tests_controller
   def edit_as_json
      puts "== Test.edit_as_json"
      self.as_json(only: [:name, :id, :job_url], include: { app_tag: { only: [:name, :id] },feature_tag: { only: [:name, :id] },owner_tag: { only: [:name, :id] }})
   end

   def self.edit_all_as_json
      puts "== Test.self.edit_as_json"
      Test.order(:name).includes(:app_tag, :feature_tag, :owner_tag).uniq{ |test| test.name }.as_json(only: [:name, :id, :job_url], include: { app_tag: { only: [:name, :id] },feature_tag: { only: [:name, :id] }} )
   end
   def trigger_jenkins_build (env_tag)
      token_url = parameterized ? "#{job_url}".gsub(".io/job/qa-tests/job", ".io/buildByToken/buildWithParameters?job=qa-tests")+"&token=QaJobToken&env=#{env_tag.name}" :"#{job_url}".gsub(".io/job/qa-tests/job", ".io/buildByToken/build?job=qa-tests") +"&token=QaJobToken"
      puts "token url = #{token_url}"
      uri = URI.parse("#{token_url}")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      response = http.request(request)
   end

   #static methods
   ##########################################################################################################
   def self.get_edit_json_all
      Test.order(:name).includes(:app_tag, :feature_tag, :owner_tag).uniq{ |test| test.name }.as_json(only: [:name, :id, :parameterized, :job_url], include: { app_tag: { only: [:name, :id] },feature_tag: { only: [:name, :id] },  owner_tag: { only: [:name, :id] } } )
   end


end
