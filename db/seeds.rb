require 'faker'

# Clear existing data
Portfolio.destroy_all
Contact.destroy_all
Organization.destroy_all
EmailTemplate.destroy_all

puts "Seeding data..."

# 1️ Organizations
orgs = []
5.times do
  orgs << Organization.create!(
    name: Faker::Company.name,
    email: Faker::Internet.email(domain: 'company.com')
  )
end

# 2️ Contacts
contacts = []
orgs.each do |org|
  rand(3..5).times do
    contacts << Contact.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      organization: org
    )
  end
end

# 3️ Portfolios
contacts.each do |contact|
  Portfolio.create!(
    contact: contact,
    name: "Growth Fund",
    balance: rand(5000..20000),
    performance: rand(-5.0..20.0).round(2)
  )
  Portfolio.create!(
    contact: contact,
    name: "Income Fund",
    balance: rand(3000..15000),
    performance: rand(-10.0..10.0).round(2)
  )
  Portfolio.create!(
    contact: contact,
    name: "Equity Fund",
    balance: rand(7000..25000),
    performance: rand(-15.0..25.0).round(2)
  )
end

# 4️ Email Templates
EmailTemplate.create!(subject: "Monthly Portfolio Digest", body: <<~BODY)
  Hello {Contact.name},

  Your organization: {Organization.name}

  Best portfolio: {Portfolio.best_performance}%
  Worst portfolio: {Portfolio.worst_performance}%
BODY

EmailTemplate.create!(subject: "Welcome Email", body: <<~BODY)
  Hi {Contact.name},

  Welcome to {Organization.name} portfolio management system!
BODY

EmailTemplate.create!(subject: "Quarterly Update", body: <<~BODY)
  Hello {Contact.name},

  Your portfolio performance this quarter:

  Best: {Portfolio.best_performance}%
  Worst: {Portfolio.worst_performance}%
BODY

puts "Seeding finished!"
puts "Created #{Organization.count} organizations, #{Contact.count} contacts, #{Portfolio.count} portfolios, #{EmailTemplate.count} templates."
