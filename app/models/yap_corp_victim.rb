class YapCorpVictim < ActiveRecord::Yapeal
	set_table_name "yap_corpVictim"
	def self.getRecentKills(amount)
		YapCorpVictim.find_by_sql(["SELECT yap_corpVictim.characterName AS victim,yap_corpVictim.killID AS killID,yap_corpVictim.shipTypeID as typeID,yap_corpVictim.characterID as victimID,yap_corpVictim.corporationID as victimCorpID,yap_corpVictim.corporationName as victimCorp, yap_corpAttackers.characterName AS attacker,yap_corpAttackers.characterID as attackerID,yap_corpAttackers.shipTypeID as attackerShipID, yap_corpKillLog.killID, EveDataDump.invTypes.typeName as shipName
			FROM yap_corpKillLog
			INNER JOIN yap_corpVictim ON yap_corpVictim.killID = yap_corpKillLog.killID
			INNER JOIN yap_corpAttackers ON yap_corpAttackers.killID = yap_corpKillLog.killID
		INNER JOIN EveDataDump.invTypes on EveDataDump.invTypes.typeID=yap_corpVictim.shipTypeID
			WHERE yap_corpVictim.allianceName <>  'Novus Dominatum'
			AND yap_corpAttackers.allianceName =  'Novus Dominatum'
			AND yap_corpAttackers.finalBlow =1
		ORDER BY  `yap_corpKillLog`.`killTime` DESC  LIMIT ?",amount])
	end
	def self.getThisWeekKillCount()
		YapCorpVictim.find_by_sql("SELECT EveDataDump.invTypes.groupID as groupID, EveDataDump.invGroups.groupName as groupName ,count(yap_corpKillLog.killID) as count,CAST(SUM(if(yap_corpVictim.allianceName =  'Novus Dominatum' AND 
(WEEK(yapeal.yap_corpKillLog.killTime) = WEEK(CURDATE())
AND YEAR(yapeal.yap_corpKillLog.killTime) = YEAR(CURDATE())), 1, 0))AS SIGNED) AS losses,CAST(SUM(if(yap_corpVictim.allianceName <>  'Novus Dominatum' AND 
(WEEK(yapeal.yap_corpKillLog.killTime) = WEEK(CURDATE())
AND YEAR(yapeal.yap_corpKillLog.killTime) = YEAR(CURDATE())), 1, 0))AS SIGNED) AS kills
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
	def self.getOverallKillCount()
		YapCorpVictim.find_by_sql("SELECT EveDataDump.invTypes.groupID as groupID, EveDataDump.invGroups.groupName as groupName ,count(yap_corpKillLog.killID) as count,CAST(SUM(if(yap_corpVictim.allianceName =  'Novus Dominatum', 1, 0)) AS SIGNED) AS losses,CAST(SUM(if(yap_corpVictim.allianceName <>  'Novus Dominatum', 1, 0))AS SIGNED) AS kills
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
