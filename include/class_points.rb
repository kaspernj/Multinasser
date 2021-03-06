class Multinasser::Points < Knj::Datarow
	def self.list(d)
		sql = "SELECT * FROM #{table} WHERE 1=1"
		
		ret = list_helper(d)
		d.args.each do |key, val|
			case key
				when "object_lookup"
					sql += " AND object_class = '#{d.db.esc(val.table)}'"
					sql += " AND object_id = '#{d.db.esc(val.id)}'"
				else
					raise sprintf(_("Invalid key: %s."), key)
			end
		end
		
		sql += ret[:sql_where]
		sql += ret[:sql_order]
		sql += ret[:sql_limit]
		
		return d.ob.list_bysql(:Points, sql)
	end
	
	def self.add(d)
		obj = d.ob.get(d.data[:object_class], d.data[:object_id]) #Ensure object exists!
	end
	
	def delete
		_kas.trans_del(self)
	end
	
	def object
		return ob.get_try(self, :object_id, self[:object_class])
	end
	
	def user
		return ob.get_try(self, :user_id, :User)
	end
	
	def title
		return _kas.trans(self, :title)
	end
	
	def descr
		return _kas.trans(self, :descr)
	end
	
	def html
		return "<a href=\"/?show=points_edit&amp;points_id=#{id}&amp;l=#{_session[:locale]}\">#{title.html}</a>"
	end
end