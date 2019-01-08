module MemeImage
  class Default
    def initialize(meme)
      @meme = meme
    end

    def path
      "/images/#{slug}"
    end

    def slug
      [
        @meme.image.id,
        @meme.title.parameterize
      ].join("-") + "." + @meme.image.blob.filename.to_s.split(".").last
    end

    def self.variant_config
      nil
    end
  end
end
