class RenameIdColumnsInActions < ActiveRecord::Migration
  def change
    rename_column :actions, :flight_action_relationships_id, :flight_action_relationship_id
    rename_column :actions, :instructions_id, :instruction_id
    rename_index :actions, 'index_actions_on_flight_action_relationships_id', 'index_actions_on_flight_action_relationship_id'
    rename_index :actions, 'index_actions_on_instructions_id', 'index_actions_on_instruction_id'
  end
end
