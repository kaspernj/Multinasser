class Multinasser::File < Knj::Datarow
	def self.list(d)
		sql = "SELECT * FROM #{table} WHERE 1=1"
		
		ret = list_helper(d)
		d.args.each do |key, val|
			case key
				when "object_lookup"
					sql += " AND object_class = '#{d.db.esc(val.table)}' AND object_id = '#{d.db.esc(val.id)}'"
				else
					raise sprintf(_("Invalid key: %s."), key)
			end
		end
		
		sql += ret[:sql_where]
		sql += ret[:sql_order]
		sql += ret[:sql_limit]
		
		return d.ob.list_bysql(:File, sql)
	end
	
	def self.add(d)
		obj = d.ob.get(d.data[:object_class], d.data[:object_id])
	end
	
	def delete
		_kas.trans_del(self)
	end
	
	def html
		return "<a href=\"/?show=file_edit&amp;file_id=#{id}&amp;l=#{_session[:locale]}\">#{self[:filename].html}</a> (<a href=\"/download.rhtml?object_class=File&amp;object_id=#{id}\">#{_("Download")}</a>)"
	end
	
	def object
		return ob.get_try(self, :object_id, self[:object_class])
	end
	
	def name
		return self[:filename]
	end
	
	def descr
		return _kas.trans(self, :descr)
	end
	
	def path
		return "#{Knj::Php.realpath(Dir.getwd + "/../files/files")}/#{id}.file"
	end
	
	def content=(content)
		Knj::Php.file_put_contents(path, content)
	end
	
	def content
		return File.read(path)
	end
	
	def content?
		return true if File.exists?(path)
		return false
	end
	
	def dl_content
		return content
	end
	
	def dl_filename
		return self[:filename]
	end
end