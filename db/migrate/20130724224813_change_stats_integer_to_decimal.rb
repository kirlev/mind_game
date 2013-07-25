class ChangeStatsIntegerToDecimal < ActiveRecord::Migration
  def up
  	change_column :statistics, :ratio, :decimal, :precision => 4, :scale => 2
  	change_column :statistics, :time, :decimal, :precision => 10, :scale => 2
  end

  def down
  	change_column :statistics, :time, :integer
  	change_column :statistics, :ratio, :integer
  end
end
