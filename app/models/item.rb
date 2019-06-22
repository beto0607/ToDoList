class Item < ApplicationRecord
    belongs_to :list
    validates :title, presence: true
    before_create do#Sets status to "ACTIVE" as default
        self.status = "ACTIVE"
    end

    scope :count_done, ->(list_id){where(list_id: list_id, status: 'DONE').count}
end
