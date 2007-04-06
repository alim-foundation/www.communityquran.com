# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def if_content(sym, &p)
    # I figure this eval is more future-proof than using @content_for_%s
    d = eval("yield :%s" % [sym], p)
    concat(capture(d, &p), p.binding) unless d.blank?
  end  
end
