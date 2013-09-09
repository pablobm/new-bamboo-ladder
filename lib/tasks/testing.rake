namespace :test do

  Rails::TestTask.new(units: "test:prepare") do |t|
    t.pattern = 'test/{models,helpers,unit,flashes}/**/*_test.rb'
  end

end
