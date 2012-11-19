class CreateSessionKeyTasks < ActiveRecord::Migration
  def change
    create_table :session_key_tasks do |t|
    	t.references :drone
    end
  end
end
