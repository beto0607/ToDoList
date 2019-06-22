class ListSerializer < BaseSerializer
    attribute :title
    attribute :due_date
    attribute :description
    attribute :items_count
    attribute :items_done_count

    has_many :items, include_links: false
    has_many :comments, include_links: false
  
end