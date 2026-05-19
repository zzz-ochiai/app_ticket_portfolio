class Admin < ApplicationRecord
  before_validation :set_default_status, on: :create

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def active_for_authentication?
    super && status == "approved"
  end
  #Devise標準条件を満たし、さらに status が approved のときだけログイン許可

  def inactive_message
    status == "pending" ? :not_approved : super
  end
  #pending なら→ "not_approved"それ以外ならDevise標準メッセージ

  private

  def set_default_status
    self.status = "pending"
  end

end
