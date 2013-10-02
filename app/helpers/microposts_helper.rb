# SOURCE: app/helpers/microposts_helper.rb
# A helper to wrap long words. 

module MicropostsHelper

  def wrap(content)
    # 'raw': raw method to prevent Rails from escaping the resulting HTML
    # 'sanitize': sanitize method needed to prevent cross-site scripting
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text :
                                  text.scan(regex).join(zero_width_space)
    end
end