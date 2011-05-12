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
	
	def delete
		_kas.trans_del(self)
	end
	
	def html
		return "<a href=\"/?show=company_edit&amp;company_id=#{id}&amp;l=#{_session[:locale]}\">#{name.html}</a>"
	end
	
	def name(args = {})
		name_str = _kas.trans(self, :name)
		name_str = "[#{_("no name")}]" if name_str.to_s.strip.length <= 0
		return name_str
	end
	
	def descr
		return _kas.trans(self, :descr)
	end
end