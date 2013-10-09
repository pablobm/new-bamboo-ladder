namespace :test do

  Rails::TestTask.new(units: "test:prepare") do |t|
    t.pattern = 'test/**/*_test.rb'
  end

end
