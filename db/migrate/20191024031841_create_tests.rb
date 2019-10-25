class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.string :name
      t.string :job_url
      t.boolean :parameterized
      t.integer :app_tag_id
      t.integer :feature_tag_id
      t.integer :owner_tag_id

      t.timestamps
    end
    add_index(:tests, [:name, :app_tag_id])
  end
end
