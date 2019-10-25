class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.string :jira_number
      t.string :body
      t.string :build_id

      t.timestamps
    end
  end
end
