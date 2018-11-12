require "test_helper"

class FieldsTest < AdminNextTestCase
  setup do
    FactoryBot.create(:map)
  end

  test 'import_fields' do
    visit_app
    login
    side_menu('Fields')
    action_menu('Import Fields')
    import_fields
    logout
  end

  private

  def import_fields
    assert_text('CSV File')
    attach_file('csvFile', Rails.root + 'test/fixtures/files/fields.csv')

    assert_difference 'Field.count', +19 do
      submit
      assert_text 'Imported 19 fields'
      click_on('Done')
    end
  end
end