require 'test_helper'

class WelcomeEmailsJobTest < ActiveJob::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament, welcome_email_sent: false, created_at: 3.days.ago)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
  end

  test "sends welcome email to new tournament 2 days after signup" do
    TournamentMailer.expects(:welcome_email).with(@user, @tournament).returns(stub(:deliver_later))
    WelcomeEmailsJob.perform_now
  end

  test "marks tournament welcome_email_sent after running the task" do
    TournamentMailer.expects(:welcome_email).returns(stub(:deliver_later))
    WelcomeEmailsJob.perform_now
    assert @tournament.reload.welcome_email_sent
  end

  test "doesn't send email if tournament marked as sent already" do
    @tournament.update_column(:welcome_email_sent, true)
    TournamentMailer.expects(:welcome_email).never
    WelcomeEmailsJob.perform_now
  end

  test "doesn't send email if owner has other tournaments that have been welcomed" do
    tournament = FactoryGirl.create(:tournament, welcome_email_sent: true)
    FactoryGirl.create(:tournament_user, user: @user, tournament: tournament)
    TournamentMailer.expects(:welcome_email).never
    WelcomeEmailsJob.perform_now
  end
end
