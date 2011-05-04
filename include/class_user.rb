class Multinasser::User < Knj::Datarow
	def self.list(d)
		sql = "SELECT * FROM #{table} WHERE 1=1"
		
		ret = list_helper(d)
		d.args.each do |key, val|
			raise sprintf(_("Invalid key: %s."), key)
		end
		
		sql += ret[:sql_where]
		sql += ret[:sql_order]
		sql += ret[:sql_limit]
		
		return d.ob.list_bysql(:User, sql)
	end
	
	def html
		return "<a href=\"/?show=user_view&amp;user_id=#{id}&amp;l=#{_session[:locale]}\">#{self[:username].html}</a>"
	end
end