class YapealDatabase < ActiveRecord::Yapeal
	set_table_name "yap_corpVictim"
	def self.getWeekKills(year,week)
		YapealDatabase.find_by_sql(["SELECT yap_corpVictim.characterName AS victim, EveDataDump.invGroups.groupName as groupName,yap_corpVictim.killID AS killID,yap_corpVictim.shipTypeID as typeID,yap_corpVictim.characterID as victimID,yap_corpVictim.corporationID as victimCorpID,yap_corpVictim.corporationName as victimCorp, yap_corpAttackers.characterName AS attacker,yap_corpAttackers.corporationName as attackerCorpName,yap_corpAttackers.corporationID as attackerCorpID,yap_corpAttackers.characterID as attackerID,yap_corpAttackers.shipTypeID as attackerShipID, yap_corpKillLog.killID, EveDataDump.invTypes.typeName as shipName
			FROM yap_corpKillLog
			INNER JOIN yap_corpVictim ON yap_corpVictim.killID = yap_corpKillLog.killID
			INNER JOIN yap_corpAttackers ON yap_corpAttackers.killID = yap_corpKillLog.killID
		INNER JOIN EveDataDump.invTypes on EveDataDump.invTypes.typeID=yap_corpVictim.shipTypeID
		INNER JOIN EveDataDump.invGroups on EveDataDump.invTypes.groupID=EveDataDump.invGroups.groupID
			WHERE yap_corpVictim.allianceID <>  99000203
			AND yap_corpAttackers.allianceID =  99000203
			AND yap_corpAttackers.finalBlow =1
			AND YEAR(`yap_corpKillLog`.`killTime`)=?
			AND WEEK(`yap_corpKillLog`.`killTime`)=?
		ORDER BY  `yap_corpKillLog`.`killTime` DESC",year,week])
	end
	def self.getKillInventory(killid)
	@items = YapealDatabase.find_by_sql(["SELECT `yap_corpItems`.flag as flag, `yap_corpItems`.killID as killID, `yap_corpItems`.lft as lft, `yap_corpItems`.lvl as lvl, `yap_corpItems`.rgt as rgt,`yap_corpItems`.qtyDropped as qtyDropped, `yap_corpItems`.qtyDestroyed as qtryDestroyed,`yap_corpItems`.singleton as singleton,`yap_corpItems`.typeID as typeID, EveDataDump.invTypes.typeName as typeName,EveDataDump.invGroups.categoryID as categoryID FROM `yap_corpItems`
INNER JOIN EveDataDump.invTypes ON EveDataDump.invTypes.typeID = yap_corpItems.typeID 
INNER JOIN EveDataDump.invGroups ON EveDataDump.invTypes.groupID = EveDataDump.invGroups.groupID
WHERE `killID` =?",killid])
	@fitting = Fitting.new(@items,getShipTypeForKill(killid))
	return @fitting
	end
	def self.getShipTypeForKill(killid)
	YapealDatabase.find_by_sql(["SELECT `shipTypeID` FROM `yap_corpVictim` WHERE `killID` =?",killid]).first.shipTypeID
	end
	def self.getShipClasses()
		YapealDatabase.find_by_sql(
		"select EveDataDump.invTypes.groupID as groupID, EveDataDump.invGroups.groupName as groupName FROM EveDataDump.invGroups
INNER JOIN EveDataDump.invTypes on EveDataDump.invTypes.groupID=EveDataDump.invGroups.groupID
WHERE(EveDataDump.invGroups.categoryID=6 OR
EveDataDump.invGroups.categoryID=23)
GROUP BY EveDataDump.invTypes.groupID
ORDER BY  EveDataDump.invGroups.categoryID,EveDataDump.invGroups.groupName ASC")
	end
	def self.getWeekKillCount(year,week)
	
		YapealDatabase.find_by_sql(["SELECT EveDataDump.invTypes.groupID as groupID, EveDataDump.invGroups.groupName as groupName ,count(yap_corpKillLog.killID) as count,CAST(SUM(if(yap_corpVictim.allianceID =  99000203 AND yap_corpAttackers.finalBlow =1 AND 
(WEEK(yapeal.yap_corpKillLog.killTime) <=> ?
AND YEAR(yapeal.yap_corpKillLog.killTime) <=> ?), 1, 0))AS SIGNED) AS losses,
CAST(SUM(if(yap_corpVictim.allianceID <>  99000203 AND yap_corpAttackers.finalBlow =1 AND 
(WEEK(yapeal.yap_corpKillLog.killTime) <=> ?
AND YEAR(yapeal.yap_corpKillLog.killTime) <=> ?), 1, 0))AS SIGNED) AS kills,yap_corpVictim.allianceID as allianceID
FROM EveDataDump.invGroups
INNER JOIN EveDataDump.invTypes on EveDataDump.invTypes.groupID=EveDataDump.invGroups.groupID
LEFT JOIN yapeal.yap_corpVictim on yapeal.yap_corpVictim.shipTypeID=EveDataDump.invTypes.typeID
LEFT JOIN yapeal.yap_corpKillLog ON yapeal.yap_corpVictim.killID = yapeal.yap_corpKillLog.killID
LEFT JOIN yapeal.yap_corpAttackers ON yapeal.yap_corpAttackers.killID = yapeal.yap_corpKillLog.killID
WHERE(EveDataDump.invGroups.categoryID=6 OR
EveDataDump.invGroups.categoryID=23)

GROUP BY EveDataDump.invGroups.groupName
		ORDER BY  EveDataDump.invGroups.categoryID,EveDataDump.invGroups.groupName ASC",week,year,week,year])
	end
	def self.getWeekKillWorth(year,week)
		YapealDatabase.find_by_sql(["SELECT sum(if(yap_corpVictim.allianceID<> 99000203 ,EveMarketData.eve_inv_types.jita_price_sell,0)) as won,
sum(if(yap_corpVictim.allianceID= 99000203 ,EveMarketData.eve_inv_types.jita_price_sell,0)) as loss
			FROM yap_corpKillLog
			INNER JOIN yap_corpVictim ON yap_corpVictim.killID = yap_corpKillLog.killID
			INNER JOIN yap_corpAttackers ON yap_corpAttackers.killID = yap_corpKillLog.killID
		INNER JOIN EveDataDump.invTypes on EveDataDump.invTypes.typeID=yap_corpVictim.shipTypeID
INNER JOIN yapeal.yap_corpItems on yapeal.yap_corpItems.killID = yap_corpVictim.killID
INNER JOIN EveMarketData.eve_inv_types on EveMarketData.eve_inv_types.type_id = yapeal.yap_corpItems.typeID
			WHERE yap_corpAttackers.finalBlow =1
and YEAR(yap_corpKillLog.killTime)=? and
WEEK(yap_corpKillLog.killTime)=?

		ORDER BY  `yap_corpKillLog`.`killTime` DESC  LIMIT 30",year,week])
	end
	def self.getOverallKillCount()
		YapealDatabase.find_by_sql("SELECT EveDataDump.invTypes.groupID as groupID, EveDataDump.invGroups.groupName as groupName ,count(yap_corpKillLog.killID) as count,CAST(SUM(if(yap_corpVictim.allianceID =  99000203, 1, 0)) AS SIGNED) AS losses,CAST(SUM(if(yap_corpVictim.allianceID <>  99000203, 1, 0))AS SIGNED) AS kills
FROM EveDataDump.invGroups
INNER JOIN EveDataDump.invTypes on EveDataDump.invTypes.groupID=EveDataDump.invGroups.groupID
LEFT JOIN yapeal.yap_corpVictim on yapeal.yap_corpVictim.shipTypeID=EveDataDump.invTypes.typeID
LEFT JOIN yapeal.yap_corpKillLog ON yapeal.yap_corpVictim.killID = yapeal.yap_corpKillLog.killID
LEFT JOIN yapeal.yap_corpAttackers ON yapeal.yap_corpAttackers.killID = yapeal.yap_corpKillLog.killID
WHERE (EveDataDump.invGroups.categoryID=6 OR
EveDataDump.invGroups.categoryID=23)
GROUP BY EveDataDump.invTypes.groupID
		ORDER BY  EveDataDump.invGroups.categoryID,EveDataDump.invGroups.groupName ASC")
	end

end
