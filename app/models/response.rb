# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  answer_choice_id :integer          not null
#

class Response < ActiveRecord::Base
  validates :user_id, presence: true
  validates :answer_choice_id,
    presence: true,
    uniqueness: {scope: :user_id}
  validate :not_duplicate_response?
  validate :not_self_response?

  belongs_to :respondent,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'User'

  belongs_to :answer_choice,
    foreign_key: :answer_choice_id,
    primary_key: :id,
    class_name: 'AnswerChoice'

  has_one :question,
    through: :answer_choice,
    source: :question

  has_one :poll,
    through: :question,
    source: :poll

  def sibling_responses
    question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    sibling_responses.exists?(user_id: self.user_id)
  end

  def not_duplicate_response?
    res = !respondent_already_answered?

    unless res
      errors[:response] << "User cannot answer the same question twice"
    end

    res
  end

  def not_self_response?
    res = question.poll.user_id != self.user_id
    unless res
      errors[:response] << "User cannot answer his/ her own poll"
    end

    res
  end
end
