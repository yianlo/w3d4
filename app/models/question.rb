# == Schema Information
#
# Table name: questions
#
#  id      :integer          not null, primary key
#  poll_id :integer          not null
#  text    :text             not null
#

class Question < ActiveRecord::Base


  validates :poll_id, presence: true
  validates :text, presence: true, uniqueness: {scope: :poll_id}

  belongs_to :poll,
    foreign_key: :poll_id,
    primary_key: :id,
    class_name: 'Poll'

  has_many :answer_choices,
    foreign_key: :question_id,
    primary_key: :id,
    class_name: 'AnswerChoice'

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def title
    text
  end

  def results
    self.answer_choices.joins(:responses)
      .where("answer_choices.question_id = ?", self.id)
      .group("answer_choices.id")
      .count("responses.user_id")

    # SELECT
    #   COUNT(responses.user_id) AS count_responses_user_id, answer_choices.id AS answer_choices_id
    # FROM
    #   "answer_choices"
    # INNER JOIN "responses" ON "responses"."answer_choice_id" = "answer_choices"."id"
    # WHERE
    #   "answer_choices"."question_id" = $1 AND (answer_choices.question_id = 1)
    # GROUP BY
    #   answer_choices.id  [["question_id", 1]]
  end

  def n_plus_1_results
    res = {}
    answer_choices.includes(:responses).each do |answer_choice|
      res[answer_choice.id] = answer_choice.responses.length
    end

    res
  end

  def sql_results
    res = ActiveRecord::Base.connection.execute(<<-SQL)
      SELECT
        answer_choices.id, COUNT(responses.user_id) AS resp
      FROM
        answer_choices
      JOIN
        responses ON answer_choices.id = responses.answer_choice_id
      WHERE
        answer_choices.question_id = #{self.id}
      GROUP BY
        answer_choices.id
    SQL

    Hash[*res.values.flatten]
  end
end
