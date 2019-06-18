class List < ApplicationRecord

    belongs_to :user

    has_many :items
    has_many :comments

    validates :title, presence:true

end
