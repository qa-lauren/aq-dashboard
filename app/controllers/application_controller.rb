class ApplicationController < ActionController::Base
   protect_from_forgery with: :exception
   before_action :set_environment
   before_action :set_rotate
   before_action :disable_rotate
   before_action :set_cache_headers
   after_action :flash_to_headers

   def set_environment
      if !session.include?(:env_id)
         session[:env_id] = EnvironmentTag.first.id
      end
      @env_tag = EnvironmentTag.find(session[:env_id])
   end

   def set_rotate
      if !session.include?(:rotate)
         session[:rotate] = false
      end
   end

   def disable_rotate
      session[:rotate] = false
   end

   def flash_to_headers
      return unless request.xhr?
      response.headers['X-Message'] = flash_message
      response.headers["X-Message-Type"] = flash_type.to_s
      flash.discard # don't want the flash to appear when you reload page
   end

   private
   def flash_message
      [:error, :warning, :success, :info].each do |type|
         f_type = flash[type]
         return f_type unless f_type.blank?
      end
      return ""
   end

   def flash_type
      [:error, :warning, :success, :info].each do |type|
         return type unless flash[type].blank?
      end
      return ""
   end

   def set_cache_headers
      response.headers["Cache-Control"] = "no-cache, no-store"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
   end
end
