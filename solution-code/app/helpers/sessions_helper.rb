module SessionsHelper
  def logout
    @current_user = nil
    session.delete(:user_id)
  end
end
