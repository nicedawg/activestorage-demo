module Memes
  class ImagesController < ApplicationController
    def show
      begin
        blob = ActiveStorage::Blob.find params[:id].split("-")[0]

        response.headers["Content-Type"] = blob.content_type

        blob.download do |chunk|
          response.stream.write(chunk)
        end
      ensure
        response.stream.close
      end
    end
  end
end
