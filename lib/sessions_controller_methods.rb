module SessionsControllerMethods
  # 登录
  def new
    return redirect_back_or_default(root_url) if logged_in?
    return render :template=>'index/login'
  end
  
  def create
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      after_logged_in()
      redirect_back_or_default("/")
    else
      flash[:error]="邮箱/密码不正确"
      redirect_to '/login'
    end
  end
  
  # 登出
  def destroy
    user = current_user
    
    if user
      reset_session_with_online_key()
      # 登出时销毁cookies令牌
      destroy_remember_me_cookie_token()
      destroy_online_record(user)
    end
    
    return redirect_to "/login"
  end
  
end
