class RatesController < ApplicationController
  def create
    @answer = Answer.find(params[:answer_id])
    @rate = current_user.rates.new(answer_id: @answer.id)
    #byebug
    @rate.save
    redirect_to request.referer
  end
end
