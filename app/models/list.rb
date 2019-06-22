class List < ApplicationRecord
    
    attr_accessor :items_count
    attr_accessor :items_done_count

    belongs_to :user

    has_many :items, dependent: :destroy
    has_many :comments, dependent: :destroy

    validates :title, presence:true

    def items_count
        self.items.count
    end

    def items_done_count
        Item.count_done(self.id)
    end

    def as_json(options)
        super(:methods => [:items_count, :items_done_count])
    end
      

    def owner? current_user
        self.user == current_user
    end
end
