namespace :app do
  desc "Recalculate ratings by replaying all results"
  task replay_results: :environment do
    Umpire.instance.replay_all!
  end
end
