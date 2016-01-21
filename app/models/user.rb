# == Schema Information
#
# Table name: users
#
#  id        :integer          not null, primary key
#  user_name :string           not null
#

class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many :authored_polls,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'Poll'

  has_many :responses,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'Response'

  def sql_exec
    ActiveRecord::Base.connection.execute(<<-SQL)
    SELECT
      polls.id, questions.id, COUNT(questions.id)
    FROM
      polls
    JOIN
      questions ON questions.poll_id = polls.id
    JOIN
      answer_choices ON answer_choices.question_id = questions.id
    JOIN
      responses ON responses.user_id = id AND answer_choices.id = response.answer_choices_id
    WHERE
      responses.user_id = #{self.id} AND polls.user_id <> id
    GROUP BY
      polls.id
    SQL
  end

  def completed_polls

  end
end
