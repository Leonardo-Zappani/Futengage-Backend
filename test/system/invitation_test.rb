require "application_system_test_case"

class ReportsTest < ApplicationSystemTestCase
  setup do
    sign_in users(:user_one)
  end

  test "creating new invite" do
    visit ('/account_invitations')
    click_on class: 'btn-circle btn-circle--primary'
    fill_in id: 'account_invitation_name', with: 'Lorem impsum'
    fill_in id: 'account_invitation_email', with: 'loremimpsum@gmail.com'
    click_on 'Enviar convite'
  end

end
  