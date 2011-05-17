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
	
	def logo_delete
		File.delete(logo_path) if File.exists?(logo_path)
		File.delete(logo_path_25) if File.exists?(logo_path_25)
	end
	
	def logo_path
		return "#{$multinasserne_config[:path]}/files/company_logos/#{id}.png"
	end
	
	def logo_path_25
		return "#{$multinasserne_config[:path]}/files/company_logos/#{id}_25.png"
	end
	
	def logo_url(extraargs = "")
		return "/image.php?picture=#{Knj::Php.urlencode(logo_path)}#{extraargs}"
	end
	
	def logo_25_generate
		raise _("This company does currently not have a logo.") if !File.exists?(logo_path)
		img = Magick::ImageList.new(logo_path)
		img.resize!(25, 25)
		File.delete(logo_path_25) if File.exists?(logo_path_25)
		img.write(logo_path_25)
	end
	
	def logo_file=(img_path)
		raise sprintf(_("File does not exist: %s."), img_path.to_s) if !File.exists?(img_path)
		img = Magick::ImageList.new(img_path)
		logo_delete
		img.write(logo_path)
		logo_25_generate
	end
	
	def logo_has?
		return File.exists?(logo_path)
	end
end