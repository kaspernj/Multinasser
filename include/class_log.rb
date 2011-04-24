class Multinasser::Log < Knj::Datarow
	def self.list(d)
		sql = "SELECT * FROM #{table} WHERE 1=1"
		
		ret = list_helper(d)
		d.args.each do |key, val|
			raise sprintf(_("Invalid key: %s"), key)
		end
		
		sql += ret[:sql_where]
		sql += ret[:sql_order]
		sql += ret[:sql_limit]
		
		return d.ob.list_bysql(:Log, sql)
	end
	
	def self.add(d)
		d.data[:date] = Knj::Datet.new if !d.data[:date]
		d.data[:post] = Knj::Php.print_r(_post, true)
		d.data[:get] = Knj::Php.print_r(_get, true)
		d.data[:meta] = Knj::Php.print_r(_meta, true)
	end
	
	def self.log(msg, objs)
		objs = [objs] if !objs.is_a?(Array)
		
		log_obj = $ob.add(:Log, {
			:message => msg
		})
		objs.each do |obj|
			link = $ob.add(:Log_link, {
				:log_id => log_obj.id,
				:object_class => obj.table,
				:object_id => obj.id
			})
		end
	end
end