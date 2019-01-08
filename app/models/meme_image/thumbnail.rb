module MemeImage
  class Thumbnail < MemeImage::Default
    def path
      "/images/thumbnail/#{slug}"
    end

    def self.variant_config
      { resize: "100x100" }
    end
  end
end
