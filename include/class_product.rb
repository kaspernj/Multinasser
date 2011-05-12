class Multinasser::Product < Knj::Datarow
	def self.list(d)
		sql = "SELECT * FROM #{table} WHERE 1=1"
		
		ret = list_helper(d)
		d.args.each do |key, val|
			raise sprintf(_("Invalid key: %s."), key)
		end
		
		sql += ret[:sql_where]
		sql += ret[:sql_order]
		sql += ret[:sql_limit]
		
		return d.ob.list_bysql(:Product, sql)
	end
	
	def self.add(d)
		d.data[:date_added] = Knj::Datet.new if !d.data.has_key?(:date_added)
	end
	
	def delete
		_kas.trans_del(self)
	end
	
	def name
		name_str = _kas.trans(self, :name)
		name_str = "[#{_("no name")}]" if name_str.to_s.strip.length <= 0
		return name_str
	end
	
	def descr
		return _kas.trans(self, :descr)
	end
	
	def companies(args = {})
		return ob.list(:Link, {"object_from_lookup" => self, "object_to_class" => "Company"}.merge(args))
	end
	
	def html
		return "<a href=\"/?show=product_edit&amp;product_id=#{id}\">#{name.html}</a>"
	end
end