class ItemSerializer < BaseSerializer
    attribute :title
    attribute :status

    has_one :list, include_links: false
end