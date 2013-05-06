class KillboardController < ApplicationController
  def index
  if(params[:week] == nil) then params[:week]=Date.today.cweek end
	if(params[:year] == nil) then params[:year]=Date.today.year end
	@week = params[:week]
  @statistics=YapealDatabase.getWeekKillCount(params[:year],params[:week])
  @amount = YapealDatabase.getWeekKillWorth(params[:year],params[:week]).first
  @kills = YapealDatabase.getWeekKills(params[:year],params[:week])
	  respond_to do |format|
		  format.html
		  format.json { render json: @statistics }
	  end
  end

  def kill
  @loadout = YapealDatabase.getKillInventory(params[:id])
  respond_to do |format|
		  format.html
  
  end
  end
  def char
  end
  def corp
  end
end
