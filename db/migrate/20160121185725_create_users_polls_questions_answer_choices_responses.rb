class CreateUsersPollsQuestionsAnswerChoicesResponses < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, null: false, unique: true
    end

    create_table :polls do |t|
      t.string :title, null: false
      t.integer :user_id, null: false
    end

    create_table :questions do |t|
      t.integer :poll_id, null: false
      t.text :text, null: false
    end

    create_table :answer_choices do |t|
      t.integer :question_id, null: false
      t.text :text, null: false
    end

    create_table :responses do |t|
      t.integer :user_id, null: false
      t.integer :answer_choice_id, null: false
    end

    add_index :polls, :user_id
    add_index :questions, :poll_id
    add_index :answer_choices, :question_id
    add_index :responses, :user_id
    add_index :responses, :answer_choice_id

  end
end
