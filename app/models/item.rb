class Item < ApplicationRecord
    belongs_to :list
    validates :title, presence: true

    def set_status
        self.status = "ACTIVE"
    end
end
