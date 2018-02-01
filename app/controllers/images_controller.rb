class ImagesController < ApplicationController
  def index
    @results = Image.all
    Rails.logger.info @results.awesome_inspect
    if @results[:success]
      render json: @results, status: :ok
    else
      render json: @results, status: :bad_request
    end
  end

  def create
    Rails.logger.info File.size(params[:image].to_io).awesome_inspect
    # @result = Image.upload(params[:image])
    # Rails.logger.info @result.awesome_inspect
    # if @result[:success]
    #   render action: :index, status: :created, notice: @result[:message]
    # else
    #   render json: @result, status: :unprocessable_entity
    # end
  end
end
