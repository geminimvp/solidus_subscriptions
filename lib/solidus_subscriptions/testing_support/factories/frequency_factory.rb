FactoryBot.define do
  factory :frequency, class: 'SolidusSubscriptions::Frequency' do
    length { 30 }
    units { 'day' }
  end
end
