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

end
