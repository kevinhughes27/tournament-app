require 'spec_helper'

feature "the mobile app" do
  fixtures :all

  before :each do
    @tournament = Tournament.find_by(handle: 'no-borders')
  end

  scenario "user clicks find and opens the drawer", js: true do
    visit("/#{@tournament.handle}")
    expect(page.find("#drawer")[:class].include?("active")).to be false
    click_on('Find')
    expect(page.find("#drawer")[:class].include?("active")).to be true
  end

end
