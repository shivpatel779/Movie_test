class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :summary
      t.string :year
      t.string :genre
      t.string :imdb_link
      t.timestamps
    end
  end
end
