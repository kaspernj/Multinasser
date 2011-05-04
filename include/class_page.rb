class Multinasser::Page < Knj::Datarow
	def self.list(d)
		join_trans_name = true if d.args["name_search"]
		
		sql = "SELECT #{table}.* FROM #{table}"
		
		if join_trans_name
			sql += "
				LEFT JOIN #{$multinasserne_config[:translations_table]} AS trans_name ON
					trans_name.object_class = 'Multinasser::Page' AND
					trans_name.object_id = Page.id AND
					trans_name.key = 'name' AND
					trans_name.locale = '#{_session[:locale]}'
			"
		end
		
		sql += " WHERE 1=1"
		
		ret = list_helper(d)
		d.args.each do |key, val|
			case key
				when "name_search"
					Knj::Strings.searchstring(val).each do |str|
						sql += " AND trans_name.value LIKE '%#{d.db.esc(str)}%'"
					end
				else
					raise sprintf(_("Invalid key: %s."), key)
			end
		end
		
		sql += ret[:sql_where]
		sql += ret[:sql_order]
		sql += ret[:sql_limit]
		
		return d.ob.list_bysql(:Page, sql)
	end
	
	def add(d)
		d.data[:date_added] = Knj::Datet.new.dbstr if !d.data[:date_added]
		d.data[:user_id] = $site.user.id if !d.data[:user_id] and $site and $site.user
		
		if d.data[:id_str].to_s.length > 0
			page_exists = d.ob.get_by(:Page, {
				:id_str => d.data[:id_str]
			})
			raise _("A page with that ID string already exists.") if page_exists
		end
	end
	
	def delete
		_kas.trans_del(self)
	end
	
	def name
		return _kas.trans(self, :name)
	end
	
	def content
		return _kas.trans(self, :content)
	end
	
	def html
		return "<a href=\"/?show=page_edit&amp;page_id=#{id}\">#{self.name.html}</a>"
	end
end