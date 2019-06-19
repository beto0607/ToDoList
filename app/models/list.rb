class List < ApplicationRecord

    belongs_to :user

    has_many :items, dependent: :destroy
    has_many :comments, dependent: :destroy

    validates :title, presence:true

    def owner? current_user
        self.user == current_user
    end
end
