class AttachmentsController < ApplicationController
  def show
    begin
      attachment = FetchAttachment.new(params[:id], params[:variant], params[:format]).call

      if attachment.data
        send_data attachment.data, type: attachment.content_type, disposition: 'inline'

      elsif attachment.id
        redirect_to attachment_path(attachment.variant, attachment.id), status: :moved_permanently

      else
        render :not_found
      end
    ensure
      response.stream.close
    end
  end
end
