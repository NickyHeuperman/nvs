class KillboardController < ApplicationController
  def index
  @statistics=YapCorpVictim.getThisWeekKillCount()
	  respond_to do |format|
		  format.html
		  format.json { render json: @statistics }
	  end
  end

  def kill
  end
end
