class UserSerializer < BaseSerializer
    attribute :email
    attribute :username

    has_many :lists, include_links: false
    has_many :comments, include_links: false
end