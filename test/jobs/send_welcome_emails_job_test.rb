require 'test_helper'

class SendWelcomeEmailsJobTest < ActiveJob::TestCase
  setup do
    @tournament = tournaments(:blank_slate_tournament)
    @tournament.update_column(:created_at, 3.days.ago)

    tournaments(:jazz_fest).destroy

    @user = @tournament.owner
    assert_equal 1, @user.tournaments.count
  end

  test "sends welcome email to new tournament 2 days after signup" do
    TournamentMailer.expects(:welcome_email).with(@user, @tournament).returns(stub(:deliver_later))
    SendWelcomeEmailsJob.perform_now
  end

  test "marks tournament welcome_email_sent after running the task" do
    TournamentMailer.expects(:welcome_email).returns(stub(:deliver_later))
    SendWelcomeEmailsJob.perform_now
    assert @tournament.reload.welcome_email_sent
  end

  test "doesn't send email if tournament marked as sent already" do
    @tournament.update_column(:welcome_email_sent, true)
    TournamentMailer.expects(:welcome_email).never
    SendWelcomeEmailsJob.perform_now
  end

  test "doesn't send email if owner has other tournaments that have been welcomed" do
    TournamentUser.create!(user: @user, tournament: tournaments(:noborders))
    TournamentMailer.expects(:welcome_email).never
    SendWelcomeEmailsJob.perform_now
  end
end
