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

class CostCenterTest < ActiveSupport::TestCase
  setup do
    @cost_center = cost_centers(:cost_center_one)
  end

  test "should create an cost center" do
    cost_center = CostCenter.new(
      id: 1231,
      account: accounts(:account),
      type: "CostCenter",
      name: "Cost_Center_test",
      description: "Description",
    )
    assert_equal "User", cost_center.account.users.name
    assert "CostCenter", cost_center.type
    assert_equal "Cost_Center_test", cost_center.name
    assert_equal "Description", cost_center.description
  end

  test "should update an cost center" do
    @cost_center.update!(
      type: "Category",
      name: "Name_test",
      description: "Description",
    )
    assert_equal "User", @cost_center.account.users.name
    assert_not_equal "CostCenter", @cost_center.type
    assert_equal "Name_test", @cost_center.name
    assert_equal "Description", @cost_center.description
  end

  test "should find an cost center by ID" do
    cost_center = CostCenter.find(@cost_center.id)
    assert_equal "User", cost_center.account.users.name
    assert_equal "one@FutEngage.io", cost_center.account.users.first.email
  end

  test "should create an user:fail" do
    cost_center = CostCenter.new(
      id: 1231,
      account: accounts(:account),
      type: nil,
      name: nil,
      description: "Description",
    )
    assert_not CostCenter.exists?(cost_center.id)
  end
end
