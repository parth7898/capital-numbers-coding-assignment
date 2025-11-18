class Organization < ApplicationRecord
   has_many :contacts, dependent: :destroy
   validates :name, presence: true
   validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true
end
