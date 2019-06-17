class Item < ApplicationRecord
    belongs_to :list
    #has_many :assinged, foreign_key: "user_id", class_name: "User" 
    validates :title, presence: true

end
