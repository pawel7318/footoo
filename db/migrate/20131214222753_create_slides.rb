class CreateSlides < ActiveRecord::Migration
	def change
		create_table :slides do |t|
			t.integer :album_id
			t.string :description
			t.timestamps
		end
		add_index :slides, [:album_id, :created_at]
	end
end
