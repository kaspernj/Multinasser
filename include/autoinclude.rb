class Multinasser
	attr_reader :lang_opts
	
	def initialize
		@lang_opts = _kas.gettext.lang_opts
	end
	
	def header(title)
		return "<h1>#{title}</h1>"
	end
	
	def request_init
		Knj::Php.header("Content-Type: text/html; charset=utf8")
		
		if _get["l"]
			_session[:locale] = _get["l"]
		elsif !_session[:locale]
			_session[:locale] = "da_DK"
		end
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
		html = "<table class=\"box\" style=\"width: #{width};\" cellspacing=\"0\" cellpadding=\"0\">"
		html += "<tbody><tr>"
		html += "<td class=\"top_left\"></td>"
		html += "<td class=\"top_middle\"></td>"
		html += "<td class=\"top_right\"></td>"
		html += "</tr><tr>"
		html += "<td class=\"left_middle\"></td>"
		html += "<td class=\"center\"\">"
		
		if title.to_s.length > 0
			html += "<div class=\"header\">#{title.to_s}</div>"
		end
	end
	
	def boxb
		html = "</td>"
		html += "<td class=\"right_middle\"></td>"
		html += "</tr><tr>"
		html += "<td class=\"left_bottom\"></td>"
		html += "<td class=\"bottom_middle\"></td>"
		html += "<td class=\"right_bottom\"></td>"
		html += "</tr></tbody></table>"
		
		return html
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