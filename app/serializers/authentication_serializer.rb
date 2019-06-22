class AuthenticationSerializer < BaseSerializer
    attribute :token
    attribute :exp
    
    has_one :user, include_links: false, include_data: true
end