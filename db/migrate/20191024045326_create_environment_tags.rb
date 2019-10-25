class CreateEnvironmentTags < ActiveRecord::Migration[6.0]
  def change
    create_table :environment_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
