set :environment, :development
set :output, 'tmp/whenever.log'

every 1.day, :at => '11:59 pm' do
  runner "Increment.add_sprint_increment"
end