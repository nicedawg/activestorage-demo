# This service takes an Attachment id and variant name
# and returns an OpenStruct with the right data and content-type
class FetchAttachment
  def initialize(id, variant, format)
    @id = id
    @variant = variant || "default"
    @format = format
  end

  def call
    if slug == canonical_slug
      OpenStruct.new(
        data: blob.service.download(blob_variant.key),
        content_type: blob.content_type || DEFAULT_SEND_FILE_TYPE
      )
    else
      OpenStruct.new(id: canonical_slug, variant: @variant)
    end
  end

  private

  def blob
    @blob ||= attachment.blob
  end

  def attachment
    @attachment ||= ActiveStorage::Attachment.find @id.split("-")[0]
  end

  def slug
    "#{@id}.#{@format}"
  end

  def canonical_slug
    @canonical_slug ||= image_klass.new(attachment.record).slug
  end

  def blob_variant
    @blob_variant ||= if variant_config
      blob.representation(variant_config).processed
    else
      blob
    end
  end

  def variant_config
    @variant_config ||= image_klass.variant_config
  end

  def image_klass
    @image_klass ||= (attachment.record_type + attachment.name.titleize + "::" + @variant.titleize).constantize
  end
end
