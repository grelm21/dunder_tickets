class Ticket < ApplicationRecord
  has_many_attached :images
  has_many_attached :documents
end
