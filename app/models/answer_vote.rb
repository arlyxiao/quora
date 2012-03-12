class AnswerVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  
  validates :user, :answer, :presence => true
  # 上面做好声明，这里就可以直接校验对象，而不是校验字段值
  # 去掉了 is_vote_up 的值校验，否则如果复制为false时通不过校验  

  # 利用模型回调方法在对象创建后，修改对应answer的vote_sum值
  after_create :update_answer_vote_sum
  def update_answer_vote_sum
    answer = self.answer
    answer.vote_sum = answer.answer_votes.map{|x| x.is_vote_up ? 1:-1 }.sum # 每次重新计算，以防止因为并发操作而出错。
    answer.save
  end
  
end
