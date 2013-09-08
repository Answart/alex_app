# SOURCE: /app/helpers/application_helper.rb
# a compact helper method for use in our site layout
# 'module ApplicationHelper' gives a way to package together related 
## methods, which can then be mixed in to Ruby classes using 'include'

module ApplicationHelper

  # Returns the full title on a per-page basis.       # Documentation comment
  def full_title(page_title)                          # Method definition
    base_title = "Ruby on Rails Tutorial Alex App"	  # Variable assignment
    if page_title.empty?                              # Boolean test
      base_title                                      # Implicit return
    else
      "#{base_title} | #{page_title}"                 # String interpolation
    end
  end
end