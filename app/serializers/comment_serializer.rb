class CommentSerializer < BaseSerializer
    attribute :description

    has_one :list, include_links: false
    has_one :user, include_links: false
end