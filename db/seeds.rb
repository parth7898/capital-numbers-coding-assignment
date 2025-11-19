# Clear existing data
Portfolio.destroy_all
Contact.destroy_all
Organization.destroy_all
EmailTemplate.destroy_all

puts "Seeding data..."

# 1️⃣ Organizations
org1 = Organization.create!(name: "Acme Corp", email: "info@acme.com")
org2 = Organization.create!(name: "Globex Inc", email: "contact@globex.com")

# 2️⃣ Contacts
contacts = []
contacts << Contact.create!(name: "Alice Johnson", email: "alice@example.com", organization: org1)
contacts << Contact.create!(name: "Bob Smith", email: "bob@example.com", organization: org1)
contacts << Contact.create!(name: "Charlie Brown", email: "charlie@example.com", organization: org1)

contacts << Contact.create!(name: "David Lee", email: "david@example.com", organization: org2)
contacts << Contact.create!(name: "Eva Green", email: "eva@example.com", organization: org2)
contacts << Contact.create!(name: "Frank Wright", email: "frank@example.com", organization: org2)

# 3️⃣ Portfolios
contacts.each do |contact|
  Portfolio.create!(contact: contact, name: "Growth Fund",  balance: rand(5000..20000), performance: rand(-5.0..20.0).round(2))
  Portfolio.create!(contact: contact, name: "Income Fund",  balance: rand(3000..15000), performance: rand(-10.0..10.0).round(2))
  Portfolio.create!(contact: contact, name: "Equity Fund",  balance: rand(7000..25000), performance: rand(-15.0..25.0).round(2))
end

# 4️⃣ Email Templates
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

puts "Seeding finished! Created #{Organization.count} organizations, #{Contact.count} contacts, #{Portfolio.count} portfolios, #{EmailTemplate.count} templates."
