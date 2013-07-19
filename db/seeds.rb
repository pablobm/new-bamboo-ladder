INITIAL_LADDER = <<EOL
mark
olly
tom
ollie
ismael
laurie
vivien
dan
claudio
niall
gwyn
joe
oscar
tony
pablo
lee
damon
EOL

User.update_all(position: nil)
INITIAL_LADDER.split.each_with_index do |name, i|
  user = User.where(email: "#{name}@new-bamboo.co.uk").first_or_initialize
  user.name ||= name.humanize
  user.position = i
  pp user
  user.save!
end
