# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_stage do
    task_id 1
    stage_id 1
    required false
    status "MyString"
  end
end
