FactoryGirl.define do
  factory :event do
    name 'Event name'
    sequence(:started_at) { |n| Time.parse('2015-01-16 17:00:00 +0900') + ((n - 1) * 12).days }
    ended_at { started_at.nil? ? Time.now : ( started_at + 1.day ) }
  end
end
