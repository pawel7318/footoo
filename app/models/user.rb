class User < ActiveRecord::Base
  # replaced by apartment gem:
  has_many :albums, dependent: :nullify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :username, exclusion: %w{footoo, admin, root}, :format => { :with => /\A[a-zA-Z]+\z/,
    :message => "Only letters allowed" }
  validates_presence_of :email

  after_create :create_schema

  private

  def create_schema    
    Apartment::Tenant.create(self.username)
  end  
end
