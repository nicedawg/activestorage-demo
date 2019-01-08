class Meme < ApplicationRecord
  has_one_attached :image

  validates :image, attached: true, content_type: ["image/png", "image/jpeg", "image/gif"]
end
