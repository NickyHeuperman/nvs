class KillboardController < ApplicationController
  def index
  @statistics=YapCorpVictim.getThisWeekKillCount()
	  respond_to do |format|
		  format.html
	  end
  end

  def kill
  end
end
