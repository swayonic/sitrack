class CreateSitrackSessionValues < ActiveRecord::Migration
  def self.up
    create_table :sitrack_session_values do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :sitrack_session_values
  end
end
