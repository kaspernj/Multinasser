class Multinasser::Log_link < Knj::Datarow
	def self.list(d)
		sql = "SELECT * FROM #{table} WHERE 1=1"
		
		ret = list_helper(d)
		d.args.each do |key, val|
			raise sprintf(_("Invalid key: %s."), key)
		end
		
		sql += ret[:sql_where]
		sql += ret[:sql_order]
		sql += ret[:sql_limit]
		
		return d.ob.list_bysql(:Log_link, sql)
	end
	
	def self.add(d)
		log = d.ob.get(:Log, d.data[:log_id])
		obj = d.ob.get(d.data[:object_class], d.data[:object_id])
	end
end