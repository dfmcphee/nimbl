set :environment, :development
set :output, 'tmp/whenever.log'

every 1.day, :at => '12:00 am' do
  runner "Increment.add_sprint_increment"
end