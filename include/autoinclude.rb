class Multinasser
	def header(title)
		return "<h1>#{title}</h1>"
	end
	
	def request_init
		_session[:locale] = "da_DK" if !_session[:locale]
	end
	
	def user
		return false if _session[:user_id].to_i <= 0
		
		begin
			return $ob.get(:User, _session[:user_id])
		rescue
			return false
		end
	end
	
	def boxt(title, width = "100%")
		html = "<table style=\"width: #{width}; border: 1px solid black;\" cellspacing=\"0\" cellpadding=\"0\">"
		html += "<tr>"
		html += "<td style=\"font-weight: bold; padding: 3px;\">"
		html += title.to_s
		html += "</td>"
		html += "</tr><tr>"
		html += "<td style=\"padding: 3px;\">"
	end
	
	def boxb
		return "</td></tr></table>"
	end
	
	def log(msg, objs)
		Multinasser::Log.log(msg, objs)
	end
	
	def require_admin
		if !$site.user
			_kas.redirect("/?show=user_login")
		end
	end
end

$site = Multinasser.new

files = [
	"conf.rb"
]
Dir.new(File.dirname(__FILE__)).each do |file|
	next if file == "." or file == ".."
	
	if file.match(/^class_(.+)\.rb$/)
		files << file
	end
end

files.each do |file|
	_kas.loadfile "#{File.dirname(__FILE__)}/#{file}"
end

$ob = Knj::Objects.new(
	:db => $db,
	:class_path => File.dirname(__FILE__),
	:module => Multinasser,
	:datarow => true
)

def _(str)
	kas = _kas
	return str if !kas
	return kas.gettext.trans(_session[:locale], str)
end