class AddTablefunction < ActiveRecord::Migration[6.1]
  def change
    enable_extension "tablefunc"
  end
end
