class AddStatusToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :status, :string
  end
end
