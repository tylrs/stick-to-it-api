class Invitation < ApplicationRecord
  belongs_to :sender, class_name: "User", dependent: :destroy
  belongs_to :recipient, class_name: "User"
  belongs_to :habit_plan, dependent: :destroy

  validates :recipient_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
