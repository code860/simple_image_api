class ImagesController < ApplicationController
  def index
    @results = Image.all
    if @results[:success]
      render json: @results, status: :ok
    else
      render json: @results, status: :bad_request
    end
  end

  def create
    @result = Image.upload(params[:image])
    if @result[:success]
      render json: @result, status: :created
    else
      render json: @result, status: :unprocessable_entity
    end
  end
end
