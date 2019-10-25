class BuildsController < ApplicationController
   before_action :set_build, only: [:update, :jenkins_refresh, :jenkins_stop]

   def update
      @build.reload
   end

   def jenkins_refresh
      @new_build = @build.jenkins_update(@env_tag.name)
      respond_to do |format|
         format.html
         format.js
      end
      test_name = Test.where(id: @build.test_id).first.name
      flash[:info] = "#{test_name} HAS BEEN REFRESHED!"
   end

   def jenkins_stop
      begin
         test = Test.where(id: test_id).pluck(:job_url)
         @build.jenkins_stop(test.job_url)
         @build.jenkins_refresh(@env_tag)
         respond_to do |format|
            format.html { render "build" }
            format.js
         end
         flash[:info] = "Build stopped!"
      rescue Exception => e
         print e
      end
   end

   private
   def set_build
      @build = Build.find(params[:id])
   end

   def build_params
      params.require(:build).permit(:env, :test_id)
   end
end
