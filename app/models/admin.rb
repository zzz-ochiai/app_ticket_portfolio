class Admin < ApplicationRecord
  before_validation :set_default_status, on: :create

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def set_default_status
    self.status = "pending"
  end

end
