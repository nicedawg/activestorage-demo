class FetchAttachment
  attr_accessor :id, :variant

  def initialize(id, variant)
    self.id = id
    self.variant = variant || "default"
  end

  def call
    attachment = ActiveStorage::Attachment.find id.split("-")[0]

    blob = attachment.blob

    image_klass = (attachment.record_type + attachment.name.titleize + "::" + variant.titleize).constantize

    blob_variant = if image_klass.variant_config
      blob.representation(image_klass.variant_config).processed
    else
      blob
    end

    OpenStruct.new(
      data: blob.service.download(blob_variant.key),
      content_type: blob.content_type || DEFAULT_SEND_FILE_TYPE
    )
  end
end
