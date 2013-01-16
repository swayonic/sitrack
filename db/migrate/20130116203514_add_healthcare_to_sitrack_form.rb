class AddHealthcareToSitrackForm < ActiveRecord::Migration
  def change
    add_column :sitrack_forms, :healthcare, :integer
  end
end
