class UserSerializer < BaseSerializer
    attributes :email, :username, :name

    has_many :lists, include_links: false
    has_many :comments, include_links: false
end