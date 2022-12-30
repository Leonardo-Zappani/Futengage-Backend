# frozen_string_literal: true

require 'test_helper'

class DomainsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @domain = domains(:one)
    @user = users(:one)
    sign_in(@user)
  end

  test 'should get index' do
    get domains_url
    assert_response :success
  end

  test 'should get new' do
    get new_domain_url
    assert_response :success
  end

  test 'should create domain' do
    assert_difference('Domain.count') do
      post domains_url,
           params: { domain: { company_id: @domain.company_id, description: @domain.description, name: @domain.name,
                               type: @domain.type } }
    end

    assert_redirected_to domain_url(Domain.last)
  end

  test 'should show domain' do
    get domain_url(@domain)
    assert_response :success
  end

  test 'should get edit' do
    get edit_domain_url(@domain)
    assert_response :success
  end

  test 'should update domain' do
    patch domain_url(@domain),
          params: { domain: { company_id: @domain.company_id, description: @domain.description, name: @domain.name,
                              type: @domain.type } }
    assert_redirected_to domain_url(@domain)
  end

  test 'should destroy domain' do
    assert_difference('Domain.count', -1) do
      delete domain_url(@domain)
    end

    assert_redirected_to domains_url
  end
end
