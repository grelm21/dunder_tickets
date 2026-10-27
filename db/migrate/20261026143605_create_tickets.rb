class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.text :message_payload
      t.text :image_payload
      t.text :document_payload
      t.text :body
      t.timestamps
    end
  end
end
