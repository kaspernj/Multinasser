class Multinasser::Link < Knj::Datarow
	def self.list(d)
		sql = "SELECT * FROM #{table} WHERE 1=1"
		
		ret = list_helper(d)
		d.args.each do |key, val|
			case key
				when "object_from_lookup"
					sql += " AND object_from_class = '#{val.table.html}' AND object_from_id = '#{val.id.sql}'"
				when "object_to_lookup"
					sql += " AND object_to_class = '#{val.table.html}' AND object_to_id = '#{val.id.sql}'"
				else
					raise sprintf(_("Invalid key: %s."), key)
			end
		end
		
		sql += ret[:sql_where]
		sql += ret[:sql_order]
		sql += ret[:sql_limit]
		
		return d.ob.list_bysql(:Link, sql)
	end
	
	def self.add(d)
		if d.data[:object_from]
			d.data[:object_from_class] = d.data[:object_from].table
			d.data[:object_from_id] = d.data[:object_from].id
			d.data.delete(:object_from)
		end
		
		if d.data[:object_to]
			d.data[:object_to_class] = d.data[:object_to].table
			d.data[:object_to_id] = d.data[:object_to].id
			d.data.delete(:object_to)
		end
		
		obj_from = d.ob.get(d.data[:object_from_class], d.data[:object_from_id])
		obj_to = d.ob.get(d.data[:object_to_class], d.data[:object_to_id])
		
		d.data[:added_user_id] = $site.user.id if !d.data.has_key?(:added_user_id) and $site and $site.user
		d.data[:date_added] = Knj::Datet.new if !d.data.has_key?(:date_added)
		
		user = d.ob.get(:User, d.data[:added_user_id]) if d.data.has_key?(:added_user_id)
		
		link_exists = $ob.get_by(:Link, {
			"object_from_class" => d.data[:object_from_class],
			"object_from_id" => d.data[:object_from_id],
			"object_to_class" => d.data[:object_to_class],
			"object_to_id" => d.data[:object_to_id]
		})
		raise _("Such a link already exists.") if link_exists
	end
	
	def object_from
		return ob.get_try(self, :object_from_id, self[:object_from_class])
	end
	
	def object_to
		return ob.get_try(self, :object_to_id, self[:object_to_class])
	end
	
	def user_added
		return ob.get_try(self, :added_user_id, :User)
	end
end