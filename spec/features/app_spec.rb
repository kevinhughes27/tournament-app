require 'spec_helper'

describe "the mobile app", type: :feature do
  fixtures :all

  before :each do
    @tournament = Tournament.find_by(handle: 'no-borders')
  end

   it "opens the drawer when the user clicks find", js: true do
    visit("/#{@tournament.handle}")
    expect(page.find("#drawer")[:class].include?("active")).to be false
    click_on('Find')
    expect(page.find("#drawer")[:class].include?("active")).to be true
  end

end
