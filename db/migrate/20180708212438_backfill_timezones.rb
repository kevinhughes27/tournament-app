class BackfillTimezones < ActiveRecord::Migration[5.2]
  def change
    return unless Rails.env.production?

    transform = {
      "GHEUN TAK 2018" => "Mumbai",
      "Eau Claire Chillout" => "Central Time (US & Canada)",
      "Test0012" => "America/New_York",
      "123456789" => "America/New_York",
      "Knockout 2018" => "Central Time (US & Canada)",
      "Bali beach Hat" => "Singapore",
      "Goosebowl 2017" => "America/New_York",
      "testdsdsf" => "America/New_York",
      "Kek" => "America/New_York",
      "DIUtest" => "America/New_York",
      "hungerfree" => "America/New_York",
      "Spirit of the Plains" => "Central Time (US & Canada)",
      "PBC Open" => "America/New_York",
      "Kk501501" => "America/New_York",
      "SotP" => "America/New_York",
      "Gold Cup" => "America/New_York",
      "Tolosa 2018" => "America/New_York",
      "teste" => "America/New_York",
      "OCO 2018 Test" => "America/New_York",
      "OCO" => "America/New_York",
      "CASEY JONES 2018" => "America/New_York",
      "135768" => "America/New_York",
      "Pes" => "America/New_York",
      "IKT Ultimate Frisbee" => "America/New_York",
      "try" => "America/New_York",
      "Medellin" => "Bogota",
      "hidden" => "America/New_York",
      "xzcg" => "America/New_York",
      "Spirit of Summer" => "America/New_York",
      "Sunny Side Cup 2018" => "America/New_York",
      "Ldss ultimate tournament" => "America/New_York",
      "Great Alaska Jamboree" => "Alaska",
      "Suba World Cup" => "America/New_York",
      "lel" => "America/New_York",
      "all in" => "America/New_York",
      "GGM Beach" => "Rome",
      "SC Tournament" => "America/New_York",
      "Bearnefactor Cup 2016" => "America/New_York",
      "BICI" => "America/New_York",
      "Skylander XVII" => "America/New_York",
      "testtest" => "America/New_York",
      "Prueba Torneo 1" => "America/New_York"
    }

    transform.map do |name, tz|
      tournament = Tournament.find_by(name: name)
      tournament.update_column(:timezone, tz)
    end
  end
end
