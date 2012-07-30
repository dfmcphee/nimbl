set :environment, :development
set :output, 'tmp/whenever.log'

every 1.day, :at => '4:30 pm' do
  runner "Increment.add_sprint_increment"
end