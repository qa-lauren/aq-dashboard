class CreateBuilds < ActiveRecord::Migration[6.0]
  def change
    create_table :builds do |t|
      t.string :env
      t.integer :test_id
      t.string :status
      t.integer :last_number
      t.datetime :last_time
      t.integer :success_number
      t.datetime :success_time
      t.integer :stability
      t.integer :last_duration
      t.integer :ave_duration

      t.timestamps
    end
    add_index(:builds, [:test_id])
  end
end
