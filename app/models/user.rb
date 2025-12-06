# app/models/user.rb
class User < ApplicationRecord
  has_many :items, dependent: :destroy
  has_one :profile
  has_secure_password
  generates_token_for(:reset_password, expires_in: 1.hours)
  generates_token_for(:user_confirmation, expires_in: 2.days)
  validates :username,
    presence: true,
    uniqueness: true,
    length: { minimum: 3, maximum: 50 },
    format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }

  validates :email_address,
    presence: true,
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :username, with: ->(username) { username.strip.downcase }
  enum :location, { gaza: "gaza", south: "south", midarea: "midarea" }, validate: { message: "invalid location" }


  def incoming_swap_requests
    Swap.joins(:receiver_item).where(receiver_item: { user_id: id })
  end

  def outgoing_swap_requests
    Swap.joins(:requester_item).where(requester_item: { user_id: id })
  end
end
