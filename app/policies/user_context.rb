class UserContext
  attr_reader :user, :cookies, :pincode

  def initialize(user, cookies, pincode)
    @user = user
    @cookies = cookies
    @pincode = pincode
  end
end
