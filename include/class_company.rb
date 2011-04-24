class Multinasser::Company < Knj::Datarow
	def self.list(d)
		sql = "SELECT * FROM #{table} WHERE 1=1"
		
		ret = list_helper(d)
		d.args.each do |key, val|
			raise sprintf(_("Invalid key: %s"), key)
		end
		
		sql += ret[:sql_where]
		sql += ret[:sql_order]
		sql += ret[:sql_limit]
		
		return d.ob.list_bysql(:Company, sql)
	end
	
	def self.add(d)
		raise "Invalid name given." if d.data[:name].to_s.strip.length <= 0
	end
	
	def html
		return "<a href=\"/?show=company_edit&amp;company_id=#{id}\">#{name.html}</a>"
	end
	
	def name
		return _kas.trans(self, :name)
	end
	
	def descr
		return _kas.trans(self, :descr)
	end
end