class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :tickets, dependent: :destroy
  # Userモデルが複数のTicketモデルを所有し、Userが削除されると関連するTicketも削除される
  
end
