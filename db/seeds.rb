# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
  User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

  Document.destroy_all
  (1..6).each do |n|
    document = Document.new
    document.title = "Document #{n}"
    document.source = 0
    file = File.open(Rails.root.join('tmp', "#{n}.pdf"), 'rb')
    document.file_source.attach(io: file, filename: "#{n}.pdf")
    document.save
  end
end
