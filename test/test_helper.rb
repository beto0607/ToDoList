ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  def createUserAndLogin
    @user ||= create(:user)
    @auth_header = { Authorization: "Bearer #{JsonWebToken.encode(user_id: @user.id)}" }
  end

  def createOtherUserAndLogin
    @other_user ||= create(:user)
    @other_user_auth_header = { Authorization: "Bearer #{JsonWebToken.encode(user_id: @other_user.id)}" }
  end
end
