class EnvironmentTagsController < ApplicationController
   skip_before_action :disable_rotate

   def select_environment
      session[:rotate] = false if params[:stop_rotate]
      env_id = session[:env_id] = params[:id]
      respond_to do |format|
         format.json { render json: EnvironmentTag.find(env_id).to_json }
         format.html { redirect_back(fallback_location: root_path) }
      end
   end

   def toggle_rotate
      session[:rotate] = !session[:rotate]
      respond_to do |format|
         format.js
         format.html { render :json => @env_tag }
      end
   end
   
end
