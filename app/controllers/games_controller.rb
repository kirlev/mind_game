class GamesController < ApplicationController
  def show
  	@game = Game.find(params[:id])
  	session[:locale] = I18n.default_locale
  	render :file => Rails.root.join('app', 'views', 'games', 'game' + params[:id].to_s, 'game')
  end

  def index
  	@games = Game.all
  end
end
