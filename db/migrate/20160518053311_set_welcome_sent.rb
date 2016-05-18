class SetWelcomeSent < ActiveRecord::Migration[5.0]

  HANDLES = [
    'greenfield-invitational',
    'aero-open',
    'kevinhughesinvitational',
    'b-league',
    'kevinwork',
    'wattest',
    'may_day',
    'no-borders',
    'richards-farts',
    'taupo-hat',
    'testing1234',
    'soggy-bottom',
    'trial',
    'kfest',
    'the-mersey-invite',
    'kevin-test-3',
    'oldie-goldie',
    'heathers-tourney',
    'test',
    'fuck',
    'testing',
    's--s',
    'ottawashowdown',
    'shayne',
    'gregs_test_tour',
    'kevin-test-2'
  ]

  def change
    return unless Rails.env.production?

    HANDLES.each do |handle|
      Tournament.where(handle: handle).update_all(welcome_email_sent: true)
    end
  end
end
