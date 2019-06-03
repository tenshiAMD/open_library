class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :title, null: false
      t.integer :source, null: false, default: 0
      t.string :url, null: true

      t.timestamps
    end

    add_index :documents, %i[source title], unique: true
  end
end
