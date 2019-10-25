class EnvironmentTag < ApplicationRecord
   VALID_ENV_TAGS = %w(dev qa prod)

   validates_inclusion_of :name, :in => VALID_ENV_TAGS
   validates_uniqueness_of :name
end
