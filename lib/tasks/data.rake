namespace :data do

  desc "Check for duplicates"
  task dupes: :environment do
    delete = ENV['DELETE'].present?
    last = nil
    puts "*** Checking dupes. " + (delete ? "Will" : "Will not") + " delete them"
    Result.in_order.each do |r|
      if last.nil?
        last = r
        next
      end
      if last.winner_id == r.winner_id && last.loser_id == r.loser_id
        time = r.created_at
        if time.sec == 0 && time.min == 0 && time.hour == 0 || time - last.created_at < 10
          print "Dupe: "
          puts "##{r.id} - #{r.winner_name} beats #{r.loser_name} on #{r.created_at}"
          r.destroy if delete
        else
          last = r
        end
      else
        last = r
      end
      #puts "##{r.id} - #{r.winner_name} beats #{r.loser_name} on #{r.created_at}"
    end
    Replayer.instance.replay_all! if delete
  end

end
