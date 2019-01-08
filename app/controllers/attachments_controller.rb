class AttachmentsController < ApplicationController
  def show
    begin
      variant = params.fetch(:variant, "default")

      attachment = ActiveStorage::Attachment.find params[:id].split("-")[0]

      blob = attachment.blob

      image_klass = (attachment.record_type + attachment.name.titleize + "::" + variant.titleize).constantize

      blob_variant = if image_klass.variant_config
        blob.representation(image_klass.variant_config).processed
      else
        blob
      end


      send_data blob.service.download(blob_variant.key),
        type: blob.content_type || DEFAULT_SEND_FILE_TYPE,
        disposition: 'inline'
    ensure
      response.stream.close
    end
  end
end
