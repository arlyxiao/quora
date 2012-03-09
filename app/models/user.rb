class User < ActiveRecord::Base
  include UserAuthMethods
  
  # 校验部分
  # 不能为空的有：用户名，登录名，电子邮箱
  # 不能重复的有：登录名，电子邮箱（大小写不区分）
  # 两次密码输入必须一样，电子邮箱格式必须正确
  # 密码允许为空，但是如果输入了，就必须是4-32
  # 用户名：是2-20位的中文或者英文，可以混写
  
  validates :name, 
    :presence => true,
    :length => 2..20,
    :uniqueness => { :case_sensitive => false },
    :format => /^([A-Za-z0-9一-龥]+)$/
  
  validates :email,
    :presence => true,
    :uniqueness => { :case_sensitive => false },
    :format => /^([A-Za-z0-9_]+)([\.\-\+][A-Za-z0-9_]+)*(\@[A-Za-z0-9_]+)([\.\-][A-Za-z0-9_]+)*(\.[A-Za-z0-9_]+)$/
  
  validates :password,
    :presence => { :on => :create },
    :confirmation => true,
    :length => { :in => 4..32 }
  
  def password
    @password
  end
  
  # 根据传入的明文密码，创建内部密钥并计算密文密码
  def password=(pwd)
    return if pwd.blank?
    
    @password = pwd
    self.salt = "#{self.object_id}#{rand}"
    self.hashed_password = self.encrypted_password(self.password)
  end
  
  # ----------- 以下是方法扩充
  include OnlineRecord::UserMethods
  include Question::UserMethods
  include Answer::UserMethods
end
