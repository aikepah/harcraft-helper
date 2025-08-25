# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_20_150002) do
  create_table "components", force: :cascade do |t|
    t.string "monster_type"
    t.string "component_type"
    t.integer "dc"
    t.boolean "volatile", default: false, null: false
    t.boolean "edible", default: false, null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parties", force: :cascade do |t|
    t.string "name"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "party_components", force: :cascade do |t|
    t.integer "party_id", null: false
    t.integer "component_id", null: false
    t.integer "quantity", default: 0
    t.string "metatag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["component_id"], name: "index_party_components_on_component_id"
    t.index ["party_id"], name: "index_party_components_on_party_id"
  end

  add_foreign_key "party_components", "components"
  add_foreign_key "party_components", "parties"
end
