class CreateJobs &lt; ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :company
      t.string :url
      t.string :location
 
      t.timestamps
    end
  end
end