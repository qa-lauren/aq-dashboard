class BuildsController < ApplicationController
   before_action :set_build, only: [:update, :jenkins_refresh, :jenkins_stop]

   def update
      puts "build update"
      @build.reload
      # byebug
      # respond_to do |format|
      #    format.html
      #    format.js
      # end
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
         test = Test.where(id: @build.test_id).first
         @build.jenkins_stop(test.job_url)
         @build.reload
         respond_to do |format|
            format.html
            format.js
         end
         flash[:info] = "Build stopped!" #never see this
      rescue Exception => e
         print e
         flash[:info] = "Stop build #{@build.last_number}"
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
