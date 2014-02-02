INITIAL_LADDER = <<EOL
tom
samuel
ismael
mark
olly
ben
oliver.n
laurie
dan
claudio
vivien
tony
gwyn
oscar
joe
niall
pablo
lee
EOL

Player.update_all(position: nil)
INITIAL_LADDER.split.each_with_index do |name, i|
  player = Player.where(name: name).first_or_initialize
  player.name ||= name.humanize
  player.position = i
  player.elo_rating = EloRating.instance.initial_rating
  pp player
  player.save!
end
