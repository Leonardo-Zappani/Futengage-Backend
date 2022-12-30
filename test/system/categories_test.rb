# frozen_string_literal: true

require 'application_system_test_case'

class DomainsTest < ApplicationSystemTestCase
  setup do
    sign_in users(:user_one)
  end

  test "Creating Categories" do
    visit categories_url
    click_on class: 'btn-circle btn-circle--primary'
    fill_in id:'category_name', with: 'Eaí meu chapa, tudo bem??'
    fill_in id:'category_description', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
    click_on 'Save'
  end

  test "Deleting Categories" do
    visit categories_url
    find('.c-table__body').hover
    click_on id: 'delete_category'
    click_on class: 'btn btn--danger'
  end

  test "Editing Categories" do
    visit categories_url
    find('.c-table__body').hover
    click_on id: 'edit_category'
    sleep 0.1
    fill_in id:'category_description', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
    click_on 'Save'
  end

end