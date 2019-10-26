class EnvironmentTag < ApplicationRecord
   VALID_ENV_TAGS = %w(dev qa prod)
   validates_inclusion_of :name, :in => VALID_ENV_TAGS
   validates_uniqueness_of :name
   
   def self.find_by_name(env_name)
      exists?(name: env_name) ? where(name: env_name).first : create(name: env_name)
   end

   def self.get_edit_json_all
      all.as_json(only: [:id, :name])
   end

   def self.get_next_env(env_tag)
      env_tag.name == "qa" ? find_by_name("dev") : find_by_name("qa")
   end

   def self.select_options
      all.map{ |env_tag| [env_tag.name, env_tag.id] }
   end
end
