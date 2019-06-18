require 'test_helper'

class CommentTest < ActiveSupport::TestCase
    test "Should create comment" do
        assert build(:comment).valid?
    end
    test "Shouln't create comment without user" do
        assert_not build(:comment, user:nil).valid?
    end
    test "Shouln't create comment without list" do
        assert_not build(:comment, list:nil).valid?
    end
    test "Shouln't create comment without text" do
        assert_not build(:comment, description:nil).valid?
    end
end
