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

# FIND REPLACE FIELD NAME FOR PROD

# Note - pool is not something this understands yet
# (top two of each pool go into winner bracket)
# but I do raw sort (not gaureenteed to work I think)
# Make sure the list sorts right before running this on
# saturday night

# BracketGame.division is really a bracket (not the same as Team.division)

namespace :nobo do

  # 10 team bracket - can't use functions ...
  task :create_coed_comp_bracket  => :environment do
    nobo_task do |noborders|
      BracketGame.where(tournament: noborders, division: 'Coed Comp').destroy_all

      # Quarter Finals
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: 'q1', bracket_top: 'a3', bracket_bottom: 'b2', field: Field.find_by(name: 'UPI2'), start_time: '8:30')
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: 'q2', bracket_top: 'b3', bracket_bottom: 'a2', field: Field.find_by(name: 'UPI3'), start_time: '8:30')
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: 'q3', bracket_top: 'b4', bracket_bottom: 'a5', field: Field.find_by(name: 'UPI4'), start_time: '8:30')
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: 'q4', bracket_top: 'a4', bracket_bottom: 'b5', field: Field.find_by(name: 'UPI5'), start_time: '8:30')

      # Semi Finals
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: 's1', bracket_top: 'a1', bracket_bottom: 'wq1', field: Field.find_by(name: 'UPI2'), start_time: '10:10')
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: 's2', bracket_top: 'b1', bracket_bottom: 'wq2', field: Field.find_by(name: 'UPI3'), start_time: '10:10')

      # Consolation Semi Finals
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: 'c1', bracket_top: 'lq1', bracket_bottom: 'wq3', field: Field.find_by(name: 'UPI4'), start_time: '10:10')
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: 'c2', bracket_top: 'lq2', bracket_bottom: 'wq4', field: Field.find_by(name: 'UPI5'), start_time: '10:10')

      # this game for 9th
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: 'c3', bracket_top: 'lq3', bracket_bottom: 'lq4', field: Field.find_by(name: 'UPI1'), start_time: '10:10')

      # Finals
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: '1st', bracket_top: 'ws1', bracket_bottom: 'ws2', field: Field.find_by(name: 'UPI2'), start_time: '1:30')
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: '3rd', bracket_top: 'ls1', bracket_bottom: 'ls2', field: Field.find_by(name: 'UPI4'), start_time: '1:30')
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: '5th', bracket_top: 'wc1', bracket_bottom: 'wc2', field: Field.find_by(name: 'UPI5'), start_time: '1:30')
      BracketGame.create(tournament: noborders, division: 'Coed Comp', bracket_code: '7th', bracket_top: 'lc1', bracket_bottom: 'lc2', field: Field.find_by(name: 'UPI1'), start_time: '11:50')
    end
  end

  task :seed_coed_comp_bracket  => :environment do
    nobo_task do |noborders|
      #TODO
    end
  end

  task :create_womens_bracket => :environment do
    nobo_task do |noborders|
      # clear
      BracketGame.where(tournament: noborders, division: 'Womens').destroy_all

      # build
      bracket = build_bracket(noborders, 'Womens')

      # Quarter Finals
      bracket.detect{ |b| b.bracket_code == 'q1'}.update_attributes(field: Field.find_by(name: 'UPI6'), start_time: '10:10')
      bracket.detect{ |b| b.bracket_code == 'q2'}.update_attributes(field: Field.find_by(name: 'UPI7'), start_time: '10:10')
      bracket.detect{ |b| b.bracket_code == 'q3'}.update_attributes(field: Field.find_by(name: 'UPI8'), start_time: '10:10')
      bracket.detect{ |b| b.bracket_code == 'q4'}.update_attributes(field: Field.find_by(name: 'UPI9'), start_time: '10:10')

      # Semi Finals
      bracket.detect{ |b| b.bracket_code == 's1'}.update_attributes(field: Field.find_by(name: 'UPI6'), start_time: '11:50')
      bracket.detect{ |b| b.bracket_code == 's2'}.update_attributes(field: Field.find_by(name: 'UPI7'), start_time: '11:50')

      # Consolation Semi Finals
      bracket.detect{ |b| b.bracket_code == 'c1'}.update_attributes(field: Field.find_by(name: 'UPI8'), start_time: '11:50')
      bracket.detect{ |b| b.bracket_code == 'c2'}.update_attributes(field: Field.find_by(name: 'UPI9'), start_time: '11:50')

      # Finals
      bracket.detect{ |b| b.bracket_code == '1st'}.update_attributes(field: Field.find_by(name: 'UPI1'), start_time: '3:10')

      bracket.detect{ |b| b.bracket_code == '3rd'}.update_attributes(field: Field.find_by(name: 'UPI6'), start_time: '1:30')
      bracket.detect{ |b| b.bracket_code == '5th'}.update_attributes(field: Field.find_by(name: 'UPI7'), start_time: '1:30')
      bracket.detect{ |b| b.bracket_code == '7th'}.update_attributes(field: Field.find_by(name: 'UPI8'), start_time: '1:30')
    end
  end

  task :create_womens_9_16_bracket => :environment do
    nobo_task do |noborders|
      # clear
      BracketGame.where(tournament: noborders, division: 'Womens 9 - 16').destroy_all

      # build
      playing_for = 9
      bracket = build_bracket(noborders, 'Womens 9 - 16', playing_for)

      # Quarter Finals
      bracket.detect{ |b| b.bracket_code == 'q1'}.update_attributes(field: Field.find_by(name: 'UPI10'), start_time: '10:10')
      bracket.detect{ |b| b.bracket_code == 'q2'}.update_attributes(field: Field.find_by(name: 'UPI11'), start_time: '10:10')
      bracket.detect{ |b| b.bracket_code == 'q3'}.update_attributes(field: Field.find_by(name: 'UPI12'), start_time: '10:10')
      bracket.detect{ |b| b.bracket_code == 'q4'}.update_attributes(field: Field.find_by(name: 'UPI13'), start_time: '10:10')

      # Semi Finals
      bracket.detect{ |b| b.bracket_code == 's1'}.update_attributes(field: Field.find_by(name: 'UPI10'), start_time: '11:50')
      bracket.detect{ |b| b.bracket_code == 's2'}.update_attributes(field: Field.find_by(name: 'UPI11'), start_time: '11:50')

      # Consolation Semi Finals
      bracket.detect{ |b| b.bracket_code == 'c1'}.update_attributes(field: Field.find_by(name: 'UPI12'), start_time: '11:50')
      bracket.detect{ |b| b.bracket_code == 'c2'}.update_attributes(field: Field.find_by(name: 'UPI13'), start_time: '11:50')

      # Finals
      bracket.detect{ |b| b.bracket_code == playing_for.ordinalize}.update_attributes(field: Field.find_by(name: 'UPI9'), start_time: '1:30')
      bracket.detect{ |b| b.bracket_code == (playing_for + 2).ordinalize }.update_attributes(field: Field.find_by(name: 'UPI10'), start_time: '1:30')
      bracket.detect{ |b| b.bracket_code == (playing_for + 4).ordinalize }.update_attributes(field: Field.find_by(name: 'UPI11'), start_time: '1:30')
      bracket.detect{ |b| b.bracket_code == (playing_for + 6).ordinalize }.update_attributes(field: Field.find_by(name: 'UPI12'), start_time: '1:30')
    end
  end

  # 6 team bracket - can't use functions ...
  task :create_womens_17_bracket  => :environment do
    nobo_task do |noborders|
      BracketGame.where(tournament: noborders, division: 'Womens').destroy_all

      # Quarter Finals
      BracketGame.create(tournament: noborders, division: 'Womens', bracket_code: 'q1', bracket_top: 'I6', bracket_bottom: 'L5', field: Field.find_by(name: 'UPI18'), start_time: '8:30')
      BracketGame.create(tournament: noborders, division: 'Womens', bracket_code: 'q2', bracket_top: 'J6', bracket_bottom: 'K5', field: Field.find_by(name: 'UPI19'), start_time: '8:30')

      # Semi Finals
      BracketGame.create(tournament: noborders, division: 'Womens', bracket_code: 's1', bracket_top: 'J5', bracket_bottom: 'wq1', field: Field.find_by(name: 'UPI2'), start_time: '11:50')
      BracketGame.create(tournament: noborders, division: 'Womens', bracket_code: 's2', bracket_top: 'I5', bracket_bottom: 'wq2', field: Field.find_by(name: 'UPI3'), start_time: '11:50')

      # Finals
      BracketGame.create(tournament: noborders, division: 'Womens', bracket_code: '17th', bracket_top: 'ws1', bracket_bottom: 'ws2', field: Field.find_by(name: 'UPI18'), start_time: '1:30')
      BracketGame.create(tournament: noborders, division: 'Womens', bracket_code: '19th', bracket_top: 'ls1', bracket_bottom: 'ls2', field: Field.find_by(name: 'UPI19'), start_time: '1:30')

      BracketGame.create(tournament: noborders, division: 'Womens', bracket_code: '21st', bracket_top: 'lq1', bracket_bottom: 'lq2', field: Field.find_by(name: 'UPI19'), start_time: '10:10')
    end
  end

  task :seed_womens_bracket => :environment do
    nobo_task do |noborders|
      teams = noborders.teams.where(division: 'Women')
      teams = teams.sort_by{ |team| team.wins * 1000 + team.points_for }.reverse
      teams = teams.unshift('placeholder') # shift so the indices line up nice for the next part

      seed_bracket(noborders, 'Womens', teams[0..8])
    end
  end

  task :seed_womens_9_16_bracket => :environment do
    nobo_task do |noborders|
      teams = noborders.teams.where(division: 'Women')
      teams = teams.sort_by{ |team| team.wins * 1000 + team.points_for }.reverse
      teams = teams.unshift('placeholder') # shift so the indices line up nice for the next part

      seed_bracket(noborders, 'Womens 9 - 6', teams[9..16])
    end
  end

  task :seed_womens_17_bracket => :environment do
    nobo_task do |noborders|
      #TODO
    end
  end

  task :create_open_bracket => :environment do
    nobo_task do |noborders|
      # clear
      BracketGame.where(tournament: noborders, division: 'Open').destroy_all

      # build
      bracket = build_bracket(noborders, 'Open')

      # Quarter Finals
      bracket.detect{ |b| b.bracket_code == 'q1'}.update_attributes(field: Field.find_by(name: 'UPI14'), start_time: '8:30')
      bracket.detect{ |b| b.bracket_code == 'q2'}.update_attributes(field: Field.find_by(name: 'UPI15'), start_time: '8:30')
      bracket.detect{ |b| b.bracket_code == 'q3'}.update_attributes(field: Field.find_by(name: 'UPI16'), start_time: '8:30')
      bracket.detect{ |b| b.bracket_code == 'q4'}.update_attributes(field: Field.find_by(name: 'UPI17'), start_time: '8:30')

      # Semi Finals
      bracket.detect{ |b| b.bracket_code == 's1'}.update_attributes(field: Field.find_by(name: 'UPI14'), start_time: '11:50')
      bracket.detect{ |b| b.bracket_code == 's2'}.update_attributes(field: Field.find_by(name: 'UPI15'), start_time: '11:50')

      # Consolation Semi Finals
      bracket.detect{ |b| b.bracket_code == 'c1'}.update_attributes(field: Field.find_by(name: 'UPI16'), start_time: '11:50')
      bracket.detect{ |b| b.bracket_code == 'c2'}.update_attributes(field: Field.find_by(name: 'UPI17'), start_time: '11:50')

      # Finals
      bracket.detect{ |b| b.bracket_code == '1st'}.update_attributes(field: Field.find_by(name: 'UPI2'), start_time: '3:10')
      bracket.detect{ |b| b.bracket_code == '3rd'}.update_attributes(field: Field.find_by(name: 'UPI3'), start_time: '3:10')
      bracket.detect{ |b| b.bracket_code == '5th'}.update_attributes(field: Field.find_by(name: 'UPI4'), start_time: '3:10')
      bracket.detect{ |b| b.bracket_code == '7th'}.update_attributes(field: Field.find_by(name: 'UPI5'), start_time: '3:10')
    end
  end

  task :create_open_9_16_bracket => :environment do
    nobo_task do |noborders|
      # clear
      BracketGame.where(tournament: noborders, division: 'Open 9 - 16').destroy_all

      # build
      playing_for = 9
      bracket = build_bracket(noborders, 'Open 9 - 16', playing_for)

      # Quarter Finals
      bracket.detect{ |b| b.bracket_code == 'q1'}.update_attributes(field: Field.find_by(name: 'UPI6'), start_time: '8:30')
      bracket.detect{ |b| b.bracket_code == 'q2'}.update_attributes(field: Field.find_by(name: 'UPI7'), start_time: '8:30')
      bracket.detect{ |b| b.bracket_code == 'q3'}.update_attributes(field: Field.find_by(name: 'UPI8'), start_time: '8:30')
      bracket.detect{ |b| b.bracket_code == 'q4'}.update_attributes(field: Field.find_by(name: 'UPI9'), start_time: '8:30')

      # Semi Finals
      bracket.detect{ |b| b.bracket_code == 's1'}.update_attributes(field: Field.find_by(name: 'UPI6'), start_time: '11:50')
      bracket.detect{ |b| b.bracket_code == 's2'}.update_attributes(field: Field.find_by(name: 'UPI7'), start_time: '11:50')

      # Consolation Semi Finals
      bracket.detect{ |b| b.bracket_code == 'c1'}.update_attributes(field: Field.find_by(name: 'UPI8'), start_time: '11:50')
      bracket.detect{ |b| b.bracket_code == 'c2'}.update_attributes(field: Field.find_by(name: 'UPI9'), start_time: '11:50')

      # Finals
      bracket.detect{ |b| b.bracket_code == playing_for.ordinalize}.update_attributes(field: Field.find_by(name: 'UPI3'), start_time: '1:30')

      bracket.detect{ |b| b.bracket_code == (playing_for + 2).ordinalize }.update_attributes(field: Field.find_by(name: 'UPI6'), start_time: '3:10')
      bracket.detect{ |b| b.bracket_code == (playing_for + 4).ordinalize }.update_attributes(field: Field.find_by(name: 'UPI7'), start_time: '3:10')
      bracket.detect{ |b| b.bracket_code == (playing_for + 6).ordinalize }.update_attributes(field: Field.find_by(name: 'UPI8'), start_time: '3:10')
    end
  end

  task :seed_open_bracket => :environment do
    nobo_task do |noborders|
      teams = noborders.teams.where(division: 'Open')
      teams = teams.sort_by{ |team| team.wins * 1000 + team.points_for }.reverse
      teams = teams.unshift('placeholder') # shift so the indices line up nice for the next part

      seed_bracket(noborders, 'Open', teams[0..8])
    end
  end

  task :seed_open_9_16_bracket => :environment do
    nobo_task do |noborders|
      teams = noborders.teams.where(division: 'Open')
      teams = teams.sort_by{ |team| team.wins * 1000 + team.points_for }.reverse
      teams = teams.unshift('placeholder') # shift so the indices line up nice for the next part

      seed_bracket(noborders, 'Open 9 - 6', teams[9..16])
    end
  end

  # Open Round Robin
  # just makes games in the schedule editor

  task :create_junior_open_bracket => :environment do
    nobo_task do |noborders|
      # clear
      BracketGame.where(tournament: noborders, division: 'Junior Open').destroy_all

      # build
      bracket = build_bracket(noborders, 'Junior Open')

      # Quarter Finals
      bracket.detect{ |b| b.bracket_code == 'q1'}.update_attributes(field: Field.find_by(name: 'UPI10'), start_time: '8:30')
      bracket.detect{ |b| b.bracket_code == 'q2'}.update_attributes(field: Field.find_by(name: 'UPI11'), start_time: '8:30')
      bracket.detect{ |b| b.bracket_code == 'q3'}.update_attributes(field: Field.find_by(name: 'UPI12'), start_time: '8:30')
      bracket.detect{ |b| b.bracket_code == 'q4'}.update_attributes(field: Field.find_by(name: 'UPI13'), start_time: '8:30')

      # Semi Finals
      bracket.detect{ |b| b.bracket_code == 's1'}.update_attributes(field: Field.find_by(name: 'UPI14'), start_time: '10:10')
      bracket.detect{ |b| b.bracket_code == 's2'}.update_attributes(field: Field.find_by(name: 'UPI15'), start_time: '10:10')

      # Consolation Semi Finals
      bracket.detect{ |b| b.bracket_code == 'c1'}.update_attributes(field: Field.find_by(name: 'UPI16'), start_time: '10:10')
      bracket.detect{ |b| b.bracket_code == 'c2'}.update_attributes(field: Field.find_by(name: 'UPI17'), start_time: '10:10')

      # Finals
      bracket.detect{ |b| b.bracket_code == '1st'}.update_attributes(field: Field.find_by(name: 'UPI1'), start_time: '1:30')
      bracket.detect{ |b| b.bracket_code == '3rd'}.update_attributes(field: Field.find_by(name: 'UPI13'), start_time: '1:30')
      bracket.detect{ |b| b.bracket_code == '5th'}.update_attributes(field: Field.find_by(name: 'UPI14'), start_time: '1:30')
      bracket.detect{ |b| b.bracket_code == '7th'}.update_attributes(field: Field.find_by(name: 'UPI15'), start_time: '1:30')
    end
  end

  task :seed_junior_open_bracket => :environment do
    nobo_task do |noborders|
      #TODO
      # C1 vs D4
      # D1 vs C4
      # C2 vs D3
      # D2 vs C3
    end
  end

  task :create_coed_rec_bracket => :environment do
    nobo_task do |noborders|
      # clear
      BracketGame.where(tournament: noborders, division: 'Coed Rec').destroy_all

      # build
      bracket = build_bracket(noborders, 'Coed Rec')

      # Quarter Finals
      bracket.detect{ |b| b.bracket_code == 'q1'}.update_attributes(field: Field.find_by(name: 'UPI1'), start_time: '2015-07-25 11:30:00 UTC')
      bracket.detect{ |b| b.bracket_code == 'q2'}.update_attributes(field: Field.find_by(name: 'UPI2'), start_time: '2015-07-25 11:30:00 UTC')
      bracket.detect{ |b| b.bracket_code == 'q3'}.update_attributes(field: Field.find_by(name: 'UPI3'), start_time: '2015-07-25 11:30:00 UTC')
      bracket.detect{ |b| b.bracket_code == 'q4'}.update_attributes(field: Field.find_by(name: 'UPI7'), start_time: '2015-07-25 11:30:00 UTC')

      # Semi Finals
      bracket.detect{ |b| b.bracket_code == 's1'}.update_attributes(field: Field.find_by(name: 'UPI1'), start_time: '2015-07-25 13:00:00 UTC')
      bracket.detect{ |b| b.bracket_code == 's2'}.update_attributes(field: Field.find_by(name: 'UPI2'), start_time: '2015-07-25 13:00:00 UTC')

      # Consolation Semi Finals
      bracket.detect{ |b| b.bracket_code == 'c1'}.update_attributes(field: Field.find_by(name: 'UPI3'), start_time: '2015-07-25 13:00:00 UTC')
      bracket.detect{ |b| b.bracket_code == 'c2'}.update_attributes(field: Field.find_by(name: 'UPI7'), start_time: '2015-07-25 13:00:00 UTC')

      # Finals
      bracket.detect{ |b| b.bracket_code == '1st'}.update_attributes(field: Field.find_by(name: 'UPI1'), start_time: '2015-07-25 16:00:00 UTC')
      bracket.detect{ |b| b.bracket_code == '3rd'}.update_attributes(field: Field.find_by(name: 'UPI2'), start_time: '2015-07-25 16:00:00 UTC')
      bracket.detect{ |b| b.bracket_code == '5th'}.update_attributes(field: Field.find_by(name: 'UPI3'), start_time: '2015-07-25 16:00:00 UTC')
      bracket.detect{ |b| b.bracket_code == '7th'}.update_attributes(field: Field.find_by(name: 'UPI7'), start_time: '2015-07-25 16:00:00 UTC')
    end
  end

  task :seed_coed_rec_bracket => :environment do
    nobo_task do |noborders|
      teams = noborders.teams.where(division: 'Coed Rec')
      teams = teams.sort_by{ |team| team.wins * 1000 + team.points_for }.reverse
      teams = teams.unshift('placeholder') # shift so the indices line up nice for the next part

      seed_bracket(noborders, 'Coed Rec', teams)
    end
  end

  def nobo_task(&block)
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    noborders = Tournament.find_by(name: 'No Borders')
    yield noborders
  end

  def build_bracket(tournament, division, playing_for = 1)
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
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: playing_for.ordinalize, bracket_top: 'ws1', bracket_bottom: 'ws2')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: (playing_for + 2).ordinalize, bracket_top: 'ls1', bracket_bottom: 'ls2')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: (playing_for + 4).ordinalize, bracket_top: 'wc1', bracket_bottom: 'wc2')
    bracket << BracketGame.create(tournament: tournament, division: division, bracket_code: (playing_for + 6).ordinalize, bracket_top: 'lc1', bracket_bottom: 'lc2')

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
