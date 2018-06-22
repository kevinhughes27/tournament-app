module Staff
  extend ActiveSupport::Concern

  STAFF = [
    'kevinhughes27@gmail.com',
    'samcluthe@gmail.com',
    'patrickkenzie@gmail.com',
    'alisonaward@gmail.com'
  ]

  def staff?
    STAFF.include?(email)
  end
end
