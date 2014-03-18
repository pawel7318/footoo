class AddDeletedAtToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :deleted_at, :datetime
  end
end
