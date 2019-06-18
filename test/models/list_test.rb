require 'test_helper'

class ListTest < ActiveSupport::TestCase
    test "Should create list"do
        assert build(:list).valid?
    end
    test "Shouldn't create list without an user"do
        assert_not build(:list, user:nil).valid?
    end
    test "Shouldn't create list without a title"do
        assert_not build(:list, title:nil).valid?
    end
end
