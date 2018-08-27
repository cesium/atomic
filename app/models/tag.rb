class Tag < ApplicationRecord
    has_many :job_taggings
    has_many :jobs, through: :job_taggings
end
