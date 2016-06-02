class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
		t.references :category, index: true, foreign_key: true
		t.string :title
		t.string :file
		t.string :md5
		t.integer :sort

		t.datetime :created_at
		t.datetime :updated_at
    end
  end
end
