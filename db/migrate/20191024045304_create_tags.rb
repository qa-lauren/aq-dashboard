class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :tag_type

      t.timestamps
    end
    add_index(:tags, :name)
  end
end
