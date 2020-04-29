module ApplicationHelper

    def auth_token
        content = "type='hidden'"
        content += "name='authenticity_token'"
        content += "value='#{form_authenticity_token}'"

        "<input #{content} >".html_safe
    end
end
