class ApplicationController < ActionController::Base

    helper_method :current_user, :logged_in?

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end
    
    def login!(user)
        session[:session_token] = user.reset_session_token!
        @current_user = user
    end
    
    def logout!
        current_user.reset_session_token!
        @current_user = session[:session_token] = nil
    end
    
    def logged_in?
        !!current_user
    end
    
    def self.strong_params(name = nil, permit: [])
        name ||= self.to_s.delete_suffix('Controller').singularize.underscore

        define_method("#{name}_params".to_sym) do 
            params.require(name.to_sym).permit(*permit)
        end
    end

    private
    
    def require_logged_out
        redirect_to user_url(current_user) if logged_in?
    end
    
    def require_current_user
        redirect_to new_user_url unless logged_in?
    end
end
