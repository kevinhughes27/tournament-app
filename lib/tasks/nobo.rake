# bracket_code schema:
"""
s* is seed position

q1 -
     \
       s1
     /    \
q2 -       \
             1st
q3 -       /
     \    /
       s2
     /
q4 -

consolation:
c1
c2

other finals:
3rd

5th

7th

prefix 'w' for winner and 'l' for loser

games push their results forward using these codes
"""

namespace :nobo do
  task :create_coed_rec_bracket => :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    noborders = Tournament.find_by(name: 'No Borders')

    # clear
    BracketGame.where(tournament: noborders, division: 'Coed Rec').destroy_all

    # build
    bracket = build_bracket(noborders, 'Coed Rec')

    # Quarter Finals
    bracket.detect{ |b| b.bracket_code == 'q1'}.update_attributes(field: Field.find_by(name: 'upi1'), start_time: '11:30')
    bracket.detect{ |b| b.bracket_code == 'q2'}.update_attributes(field: Field.find_by(name: 'upi2'), start_time: '11:30')
    bracket.detect{ |b| b.bracket_code == 'q3'}.update_attributes(field: Field.find_by(name: 'upi3'), start_time: '11:30')
    bracket.detect{ |b| b.bracket_code == 'q4'}.update_attributes(field: Field.find_by(name: 'upi7'), start_time: '11:30')

    # Semi Finals
    bracket.detect{ |b| b.bracket_code == 's1'}.update_attributes(field: Field.find_by(name: 'upi1'), start_time: '1:00')
    bracket.detect{ |b| b.bracket_code == 's2'}.update_attributes(field: Field.find_by(name: 'upi2'), start_time: '1:00')

    # Consolation Semi Finals
    bracket.detect{ |b| b.bracket_code == 'c1'}.update_attributes(field: Field.find_by(name: 'upi3'), start_time: '1:00')
    bracket.detect{ |b| b.bracket_code == 'c2'}.update_attributes(field: Field.find_by(name: 'upi7'), start_time: '1:00')

    # Finals
    bracket.detect{ |b| b.bracket_code == '1st'}.update_attributes(field: Field.find_by(name: 'upi1'), start_time: '4:00')
    bracket.detect{ |b| b.bracket_code == '3rd'}.update_attributes(field: Field.find_by(name: 'upi2'), start_time: '4:00')
    bracket.detect{ |b| b.bracket_code == '5th'}.update_attributes(field: Field.find_by(name: 'upi3'), start_time: '4:00')
    bracket.detect{ |b| b.bracket_code == '7th'}.update_attributes(field: Field.find_by(name: 'upi7'), start_time: '4:00')
  end

  task :seed_coed_rec_bracket => :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    noborders = Tournament.find_by(name: 'No Borders')
    teams = noborders.teams.where(division: 'Coed Rec')
    teams = teams.sort{ |team| team.wins * 1000 + team.points_for }
    teams = teams.unshift('placeholder') # shift so the indices line up nice for the next part

    seed_bracket(noborders, 'Coed Rec', teams)
  end

  def build_bracket(tournament, division)
    bracket = []

    # Quarter Finals
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: 'q1', bracket_top: 's1', bracket_bottom: 's8')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: 'q2', bracket_top: 's2', bracket_bottom: 's7')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: 'q3', bracket_top: 's3', bracket_bottom: 's6')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: 'q4', bracket_top: 's4', bracket_bottom: 's5')

    # Semi Finals
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: 's1', bracket_top: 'wq1', bracket_bottom: 'wq2')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: 's2', bracket_top: 'wq3', bracket_bottom: 'wq4')

    # Consolation Semi Finals
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: 'c1', bracket_top: 'lq1', bracket_bottom: 'lq2')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: 'c2', bracket_top: 'lq3', bracket_bottom: 'lq4')

    # Finals
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: '1st', bracket_top: 'ws1', bracket_bottom: 'ws2')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: '3rd', bracket_top: 'ls1', bracket_bottom: 'ls2')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: '5th', bracket_top: 'wc1', bracket_bottom: 'wc2')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: '7th', bracket_top: 'lc1', bracket_bottom: 'lc2')

    bracket
  end

  def seed_bracket(tournament, division, teams)
    BracketGame.find_by(tournament: tournament, division: division, bracket_code: 'q1').update_attributes(
      home: teams[1], away: teams[8]
    )

    BracketGame.find_by(tournament: tournament, division: division, bracket_code: 'q2').update_attributes(
      home: teams[2], away: teams[7]
    )

    BracketGame.find_by(tournament: tournament, division: division, bracket_code: 'q3').update_attributes(
      home: teams[3], away: teams[6]
    )

    BracketGame.find_by(tournament: tournament, division: division, bracket_code: 'q4').update_attributes(
      home: teams[4], away: teams[5]
    )
  end
end
