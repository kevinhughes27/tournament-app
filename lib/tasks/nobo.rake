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
    noborders = Tournament.find_by(name: 'No Borders')

    # clear
    BracketGame.where(tournament: noborder, division: 'Coed Rec').destroy_all

    # Quarter Finals
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: 'q1', bracket_top: 's1', bracket_bottom: 's8', field: Field.find_by(name: 'upi1'), start_time: '11:30')
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: 'q2', bracket_top: 's2', bracket_bottom: 's7', field: Field.find_by(name: 'upi2'), start_time: '11:30')
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: 'q3', bracket_top: 's3', bracket_bottom: 's6', field: Field.find_by(name: 'upi3'), start_time: '11:30')
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: 'q4', bracket_top: 's4', bracket_bottom: 's5', field: Field.find_by(name: 'upi7'), start_time: '11:30')

    # Semi Finals
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: 's1', bracket_top: 'wq1', bracket_bottom: 'wq2', field: Field.find_by(name: 'upi1'), start_time: '1:00')
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: 's2', bracket_top: 'wq3', bracket_bottom: 'wq4', field: Field.find_by(name: 'upi2'), start_time: '1:00')

    # Consolation Semi Finals
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: 'c1', bracket_top: 'lq1', bracket_bottom: 'lq2', field: Field.find_by(name: 'upi3'), start_time: '1:00')
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: 'c2', bracket_top: 'lq3', bracket_bottom: 'lq4', field: Field.find_by(name: 'upi7'), start_time: '1:00')

    # Finals
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: '1st', bracket_top: 'ws1', bracket_bottom: 'ws2', field: Field.find_by(name: 'upi1'), start_time: '4:00')
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: '3rd', bracket_top: 'ls1', bracket_bottom: 'ls2', field: Field.find_by(name: 'upi2'), start_time: '4:00')
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: '5th', bracket_top: 'wc1', bracket_bottom: 'wc2', field: Field.find_by(name: 'upi3'), start_time: '4:00')
    BracketGame.create(tournament: noborders, division: 'Coed Rec', bracket_code: '7th', bracket_top: 'lc1', bracket_bottom: 'lc2', field: Field.find_by(name: 'upi7'), start_time: '4:00')
  end

  task :seed_coed_rec_bracket => :environment do
    noborders = Tournament.find_by(name: 'No Borders')
    teams = noborders.teams.where(division: 'Coed Rec')
    teams = teams.sort{ |team| team.wins * 1000 + team.points_for }
    teams = teams.unshift('placeholder') # shift so the indices line up nice for the next part

    BracketGame.find_by(tournament: noborder, division: 'Coed Rec', bracket_code: 'q1').update_attributes(
      home: teams[1], away: teams[8]
    )

    BracketGame.find_by(tournament: noborder, division: 'Coed Rec', bracket_code: 'q2').update_attributes(
      home: teams[2], away: teams[7]
    )

    BracketGame.find_by(tournament: noborder, division: 'Coed Rec', bracket_code: 'q3').update_attributes(
      home: teams[3], away: teams[6]
    )

    BracketGame.find_by(tournament: noborder, division: 'Coed Rec', bracket_code: 'q4').update_attributes(
      home: teams[4], away: teams[5]
    )
  end

end
