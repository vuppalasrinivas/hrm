class Employee < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable
  has_many :leave
  belongs_to :role
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id" 
  belongs_to :manager, class_name: "Employee"
  has_many :payrolls
  validates_presence_of :first_name, :last_name, :role_id, :department_id, :personal_email, :contact_no, :actual_dob, :certificate_dob, :date_of_joining 
  validates_presence_of :graduation, :source_of_hire, :address
  #validates_presence_of :ttid, :emergency_name, :emergency_contact_no, :health_insurance_card_no, :pf_no, :aadhar_no, :pancard_no, :passport_no
  #validates_presence_of :prev_years_of_exp, :father_or_spouse, :nationality, :date_of_resignation, :lwd
  belongs_to :department
  validates_uniqueness_of :ttid
  
  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@traveltripper\.com\z/,
                  message: "must be a traveltripper.com account" }

  has_attached_file :profile_picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/profilepic.png"
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\z/
  before_create :set_days_of_leave
  has_many :announcements  

  def fullname
  	first_name.capitalize.to_s + " " + middle_name.capitalize.to_s + " " + last_name.capitalize.to_s
  end
  
  def emp_birthday    
    custom_date = actual_dob.strftime("%d-%b-") + Time.now.strftime("%y")
    p Date.strptime(custom_date, "%d-%b-%y")    
  end

  def today_birthday
    actual_dob.strftime("%m%d")
  end

  private
    def set_days_of_leave
      self.days_of_leave = ((Time.now.end_of_year - self.date_of_joining)/1.month.second).ceil * 2     
    end

end
