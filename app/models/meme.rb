class Meme < ApplicationRecord
  has_one_attached :image

  def image_slug
    # 1-not-sure-if.jpg
    [
      self.id,
      self.title.parameterize
    ].join("-") + "." + image.blob.filename.to_s.split(".").last
  end
end
