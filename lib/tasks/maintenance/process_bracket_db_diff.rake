namespace :m do
  task :process_bracket_db_diff => :environment do
    dbDiff = JSON.parse(
      File.read('./db/bracket_db_diff.json')
    )

    dbDiff.each do |handle, diff|
      puts "[#{handle}]"
      Division.where(bracket_type: handle).find_each do |division|
        diff['old'].each_with_index do |_, idx|
          proccess_division(
            division,
            diff['old'][idx],
            diff['new'][idx]
          )
        end
      end
    end
  end
end

def proccess_division(division, old_attrs, new_attrs)
  puts "[#{division.bracket_type}] processing: #{old_attrs}"
  is_place = old_attrs['position'].present?

  if is_place
    process_place(division, old_attrs, new_attrs)
  else
    process_game(division, old_attrs, new_attrs)
  end
end

def process_game(division, old_attrs, new_attrs)
  puts "[#{division.bracket_type}] processing game"
  game = division.games.find_by(remap(old_attrs))
  if game
    game.update_columns(remap(new_attrs)) if game
    puts "[#{division.bracket_type}] done"
  else
    puts "[#{division.bracket_type}] game not found: #{remap(old_attrs)}"
  end
end

def process_place(division, old_attrs, new_attrs)
  puts "[#{division.bracket_type}] process place"
  place = division.places.find_by(old_attrs)
  if place
    place.update_columns(new_attrs)
    puts "[#{division.bracket_type}] done"
  else
    puts "[#{division.bracket_type}] place not found: #{old_attrs}"
  end
end

def remap(template_diff)
  template_diff.delete('place')

  keymap = {
    "home" => "home_prereq_uid",
    "away" => "away_prereq_uid",
    "uid" => "bracket_uid"
  }

  template_diff.map do |k, v|
    if keymap.key?(k)
      [keymap[k], v]
    else
      [k, v]
    end
  end.to_h
end
