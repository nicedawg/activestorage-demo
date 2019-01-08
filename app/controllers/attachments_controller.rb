class AttachmentsController < ApplicationController
  def show
    begin
      attachment = FetchAttachment.new(params[:id], params[:variant]).call

      send_data attachment.data, type: attachment.content_type, disposition: 'inline'
    ensure
      response.stream.close
    end
  end
end
