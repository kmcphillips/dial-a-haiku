class AddHaikuToResponse < ActiveRecord::Migration[7.0]
  def change
    add_column :responses, :haiku, :text
  end
end
