module ApplicationHelper
  def h1(&block)
    "<h1 class=\"text-lg md:text-3xl font-bold\">#{capture(&block)}</h1>".html_safe
  end
end
