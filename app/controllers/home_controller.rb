class HomeController < ApplicationController
  def index
  @kills = YapCorpVictim.getRecentKills(10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @kills }
  end
  end
end
