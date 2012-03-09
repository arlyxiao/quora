require 'digest/sha1'

module UserAuthMethods
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
  end
  
  module InstanceMethods
    # 创建 记住我 cookie 登录令牌
    def create_remember_me_cookie_token(expire = 30)
      value = "#{self.email}:#{expire.to_s}:#{self.hashed_remember_me_cookie_token_string}"
      
      return {
        :value   => value,
        :expires => expire.days.from_now,
        :domain  => Rails.application.config.session_options[:domain]
      }
    end
    
    # 使用SHA1算法生成令牌字符串，用于记住我的cookie
    def hashed_remember_me_cookie_token_string
      return Digest::SHA1.hexdigest("#{self.name}#{self.hashed_password}#{self.salt}onlyecho")
    end
    
    # 验证外部传入的密码是否正确
    def password_valid?(input_password)
      return self.hashed_password == self.encrypted_password(input_password)
    end
    
    # 使用SHA1算法，根据内部密钥和明文密码计算加密后的密码
    def encrypted_password(input_password)
      Digest::SHA1.hexdigest("#{input_password}jerry_sun#{self.salt}")
    end
    
  end
  
  module ClassMethods
    # 电子邮箱或用户名 认证
    # 接收外部传入参数，尝试返回用户实例，定义为类方法
    def authenticate(email_or_name, password)
      user = User.find_by_email(email_or_name) || User.find_by_name(email_or_name)
      return nil if user.blank?
      return user if user.password_valid?(password)
      return nil
    end
    
    # 验证 记住我 cookies令牌
    def authenticate_remember_me_cookie_token(token)
      email, expire, hashed_string = token.split(':')
      
      user = User.find_by_email(email)
      user = nil if !user.blank? && hashed_string != user.hashed_remember_me_cookie_token_string
      return user
    end
  end
end