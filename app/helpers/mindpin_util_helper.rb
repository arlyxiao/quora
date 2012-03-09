# -*- encoding : utf-8 -*-
module MindpinUtilHelper
  
  # 给当前页面设置标题
  def htitle(str)
    content_for :title do
      str
    end
  end
  
end
