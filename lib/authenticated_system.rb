module AuthenticatedSystem

  public
  
  # 当某个controller需要登录验证时，加上这个 before_filter
  def login_required(info=nil)
    logged_in? || access_denied(info)
  end

  private

  # 根据session里的信息，获取当前登录用户
  # 如果没有登录，则返回 nil
  def current_user
    @current_user ||= (
      login_from_session || login_from_cookie
    ) unless false == @current_user
  end

  # 设定指定对象为当前会话用户对象，并将基本信息传入session保存
  def current_user=(user)
    session[:user_id] = (user.blank? ? nil : user.id)
    @current_user = user || false
  end

  # 判断用户是否登录，同时预加载 @current_user 对象
  def logged_in?
    !!current_user
  end

  def access_denied(info)
    return render :status=>401, :text => "ACCESS DENIED 需要先登录才可访问 #{info}" if request.xhr?
    
    store_location
    flash[:notice] = info
    redirect_to '/login', :status=>302
  end

  # 记录下access denied 重定向前试图访问的URL
  def store_location
    session[:return_to] = request.url
  end

  # 重定向到之前 store_location 记录的URL
  def redirect_back_or_default(default)
    url = session[:return_to] || default
    redirect_to url, :status=>302
    session[:return_to] = nil
  end

  # 将几个方法添加到helper方法中，以便在页面使用
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  # Called from #current_user.  First attempt to login by the user id stored in the session.
  def login_from_session
    return User.find(session[:user_id]) if session[:user_id]
  rescue Exception
    return nil
  end

  def remember_me_cookie_key
    return :remember_me_token if Rails.env.production?
    return :remember_me_token_devel
  end

  # 被 current_user 方法调用 如果登录时勾选了 记住我，此方法会生效
  def login_from_cookie    
    if !cookies[remember_me_cookie_key].blank?
      user = User.authenticate_remember_me_cookie_token(cookies[remember_me_cookie_key])
      return user if !user.blank?
    end
  end
  
end