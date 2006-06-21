class CreateSitrackViewColumns < ActiveRecord::Migration
  def self.up
    create_table :sitrack_view_columns do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :sitrack_view_columns
  end
end
