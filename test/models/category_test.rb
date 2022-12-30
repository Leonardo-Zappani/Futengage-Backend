# frozen_string_literal: true

# == Schema Information
#
# Table name: domains
#
#  id           :bigint           not null, primary key
#  description  :text
#  discarded_at :datetime
#  name         :string           not null
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint           not null
#
# Indexes
#
#  index_domains_on_account_id                            (account_id)
#  index_domains_on_account_id_and_type_and_discarded_at  (account_id,type,discarded_at)
#  index_domains_on_discarded_at                          (discarded_at)
#  index_domains_on_type                                  (type)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require "test_helper"

class DomainTest < ActiveSupport::TestCase
  setup do
    @category = categories(:category_one)
  end

  test "should create an category" do
    category = Category.new(
      id: 1231,
      account: accounts(:account),
      type: "Category",
      name: "category_test",
      description: "Description",
    )
    assert_equal "User", category.account.users.name
    assert "CostCenter", category.type
    assert_equal "category_test", category.name
    assert_equal "Description", category.description
  end

  test "should update an category" do
    @category.update!(
      type: "Category",
      name: "Name_test",
      description: "Description",
    )
    assert_equal "User", @category.account.users.name
    assert_not_equal "CostCenter", @category.type
    assert_equal "Name_test", @category.name
    assert_equal "Description", @category.description
  end

  test "should find an category by ID" do
    category = Category.find(@category.id)
    assert_equal "User", category.account.users.name
    assert_equal "one@procfy.io", category.account.users.first.email
  end

  test "should create an category:fail" do
    category = CostCenter.new(
      id: 1231,
      account: accounts(:account),
      type: nil,
      name: nil,
      description: "Description",
    )
    assert_not CostCenter.exists?(category.id)
  end
end
