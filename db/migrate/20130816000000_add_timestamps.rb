class AddTimestamps < ActiveRecord::Migration
  START_OF_TIME = Time.parse('2013-07-20 00:00:00')

  def change
    change_table(:players){|t| t.timestamps }
    change_table(:users){|t| t.timestamps }
    change_table(:results){|t| t.timestamps }

    Player.update_all(created_at: Time.now, updated_at: Time.now)
    User.update_all(created_at: Time.now, updated_at: Time.now)
    populate_result_timestamps
  end

  def populate_result_timestamps
    days = 0
    each_weekday do
      days += 1
    end

    games_per_day = Result.count / days

    results = Result.order('id ASC').to_a
    days_passed = 0
    each_weekday do |time|
      if results.count % (days-days_passed) == 0
        games_per_day = results.count / (days-days_passed)
      end
      games_per_day.times do
        r = results.shift
        r.update_attributes(created_at: time, updated_at: time)
      end
      days_passed += 1
    end

  end

  def each_weekday(&block)
    t = START_OF_TIME
    while t <= Time.now
      unless [6, 0].include?(t.wday)
        block.call(t)
      end
      t += 1.day
    end
  end
end
