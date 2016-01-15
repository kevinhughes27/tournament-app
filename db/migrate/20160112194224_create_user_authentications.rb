class CreateUserAuthentications < ActiveRecord::Migration
  def change
    create_table "user_authentications", :force => true do |t|
      t.integer  "user_id"
      t.string   "provider"
      t.string   "uid"
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
    end
    add_index "user_authentications", ["provider"]
    add_index "user_authentications", ["user_id"]
  end
end
