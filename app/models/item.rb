class Item < ApplicationRecord
    belongs_to :list
    validates :title, presence: true
    before_create do#Sets status to "ACTIVE" as default
        self.status = "ACTIVE"
    end
end
