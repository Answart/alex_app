include ApplicationHelper

# to replace the 'let(:base_title) { "Ruby on Rails Tutorial Sample
# App" }' in static_pages_spec.rb

def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end