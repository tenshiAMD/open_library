FactoryBot.define do
  factory :document, class: Document do
    sequence(:title) { |n| "Document #{n}" }
    source { Document::SOURCES[Faker::Number.between(0, Document::SOURCES.count - 1)] }
    url { Faker::Internet.url }
  end
end
