require 'test_helper'

class ItemTest < ActiveSupport::TestCase
    test "Should create Item" do
        assert build(:item).valid?
    end
    test "Shouldn't create item without title" do
        assert_not build(:item, title:nil).valid?
    end
    test "Item initial status must be ACTIVE" do
        assert_equal create(:item).status, "ACTIVE"
    end
end
