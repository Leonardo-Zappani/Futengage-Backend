# # frozen_string_literal: true

# require 'test_helper'

# class AccountInvitationsControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @account_invitation = account_invitations(:one)
#   end

#   test 'should get index' do
#     get account_invitations_url
#     assert_response :success
#   end

#   test 'should get new' do
#     get new_account_invitation_url
#     assert_response :success
#   end

#   test 'should create account_invitation' do
#     assert_difference('AccountInvitation.count') do
#       post account_invitations_url,
#            params: { account_invitation: { account_id: @account_invitation.account_id, email: @account_invitation.email,
#                                            invited_by_id: @account_invitation.invited_by_id, role: @account_invitation.role, token: @account_invitation.token } }
#     end

#     assert_redirected_to account_invitation_url(AccountInvitation.last)
#   end

#   test 'should show account_invitation' do
#     get account_invitation_url(@account_invitation)
#     assert_response :success
#   end

#   test 'should get edit' do
#     get edit_account_invitation_url(@account_invitation)
#     assert_response :success
#   end

#   test 'should update account_invitation' do
#     patch account_invitation_url(@account_invitation),
#           params: { account_invitation: { account_id: @account_invitation.account_id, email: @account_invitation.email,
#                                           invited_by_id: @account_invitation.invited_by_id, role: @account_invitation.role, token: @account_invitation.token } }
#     assert_redirected_to account_invitation_url(@account_invitation)
#   end

#   test 'should destroy account_invitation' do
#     assert_difference('AccountInvitation.count', -1) do
#       delete account_invitation_url(@account_invitation)
#     end

#     assert_redirected_to account_invitations_url
#   end
# end
