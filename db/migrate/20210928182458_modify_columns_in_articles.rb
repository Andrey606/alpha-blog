class ModifyColumnsInArticles < ActiveRecord::Migration[6.1]
  def change
    remove_column :articles, :descripton, :text
    add_column :articles, :description, :text
  end
end
