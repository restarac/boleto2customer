module ApplicationHelper
  BASE_TITLE = "Boleto 2 Custumer App"
	  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    if page_title.empty?
      BASE_TITLE
    else
      page_title + " | " + BASE_TITLE
    end
  end
end
