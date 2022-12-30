# frozen_string_literal: true

require 'application_system_test_case'

class AccountInvitationsTest < ApplicationSystemTestCase

  test 'Creating user' do
    visit @imports
    click_on 'Inscrever-se'
    fill_in id: 'user_account_attributes_company_attributes_name', with: 'Eaí meu chapa'
    fill_in id: 'user_first_name', with: 'Eaí meu chapa'
    fill_in id: 'user_last_name', with: 'Eaí meu chapa'
    fill_in id: 'user_email', with: 'eaimeuchapa@chapa.com'
    fill_in id: 'user_password', with: 'eaimeuchapa'
    fill_in id: 'user_password_confirmation', with: 'eaimeuchapa'
    check 'tos'
    click_on 'Inscrever-se'
  end
  
end
