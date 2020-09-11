class RenameTargetsToRefTargets < ActiveRecord::Migration[5.1]
  def change
    rename_table :targets, :ref_targets
  end
end
