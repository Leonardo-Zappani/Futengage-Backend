require "application_system_test_case"

class ImportsTest < ApplicationSystemTestCase
  setup do
    sign_in users(:user_one)
  end

  test 'Creating import with correct file' do
    visit imports_url 
    click_on id: 'button_delete_file'
    sleep 0.2
    click_on class: 'btn btn--danger'
    visit imports_url 
    click_on id: 'file_upload_upper_button'
    sleep 0.1
    attach_file "import_file", file_fixture("example_100%.xlsx")
    click_on id: "upload_file_button"
    sleep 2
    visit imports_url 
    assert_selector ".paragraph-muted", text: "100.0%"
  end

  test 'Creating import with not complete file' do
    visit imports_url 
    click_on id: 'file_upload_upper_button'
    sleep 0.1
    attach_file "import_file", file_fixture("example_1%.xlsx")
    click_on id: "upload_file_button"
    sleep 0.2
    assert_selector ".paragraph-muted", text: "0.26%"
  end

  test 'Creating import an then delete' do
    visit imports_url 
    click_on id: 'button_delete_file'
    sleep 0.2
    click_on class: 'btn btn--danger'
    visit imports_url 
    click_on id: 'file_upload_upper_button'
    sleep 0.1
    attach_file "import_file", file_fixture("example_1%.xlsx")
    click_on id: "upload_file_button"
    sleep 0.2
    click_on id: 'button_delete_file'
    sleep 0.2
    click_on class: 'btn btn--danger'
  end

  test 'Creating import an then download it' do
    visit imports_url 
    click_on id: 'button_delete_file'
    sleep 0.2
    click_on class: 'btn btn--danger'
    visit imports_url 
    click_on id: 'file_upload_upper_button'
    sleep 0.1
    attach_file "import_file", file_fixture("example_1%.xlsx")
    click_on id: "upload_file_button"
    sleep 0.2
    click_link('download_file')
  end

  test 'Creating import an then verifying the transaction' do
    visit imports_url 
    click_on id: 'button_delete_file'
    sleep 0.2
    click_on class: 'btn btn--danger'
    visit imports_url 
    click_on id: 'file_upload_upper_button'
    sleep 0.1
    attach_file "import_file", file_fixture("file_transaction_test.xlsx")
    click_on id: "upload_file_button"
    sleep 0.2
    visit transactions_url
    click_on id: 'account_list_button'
    sleep 0.2
    click_on 'Teste Conta'
    page.has_content?('Teste Mensalidade')
    page.has_content?('15,00')
    page.has_content?('À vista')
    page.has_content?('Teste conta')
  end

end
