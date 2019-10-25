class Note < ApplicationRecord
   belongs_to :build, optional: true

end
