class TestsController < ApplicationController
   # skip_before_action :verify_authenticity_token, only: [:edit, :update, :destroy]
   before_action :set_test, only: [:edit, :update, :destroy, :jenkins_build]

   def index
      @tests=Test.get_edit_json_all
   end

   def edit
      respond_to do |format|
         format.js
      end
   end

   def jenkins_build
      if @test.trigger_jenkins_build(@env_tag)
         flash[:info] = "Build for #{ @test.name } successfully started"
      else
         flash[:info] = "Error starting job for #{ @test.name }. Token is likely not set."
      end
      respond_to do |format|
         format.js
      end
      #the trigger_build.js.erb file and build and refresh^ in routes
   end

   def update
      name = @test.name
      test_params = params[:test]
      app_tag_id = test_params[:app_tag]
      if app_tag_id != "0"
         @test.app_tag_id = app_tag_id
      else
         app_tag = @test.app_tag
         app_tag.app_tests.delete(@test) if app_tag
      end
      feature_tag_id = test_params[:feature_tag]
      if feature_tag_id != "0"
         @test.feature_tag_id = feature_tag_id
      else
         feature_tag = @test.feature_tag
         feature_tag.feature_tests.delete(@test) if feature_tag
      end
      owner_tag_id = test_params[:owner_tag]
      if owner_tag_id != "0"
         @test.owner_tag_id = owner_tag_id
      else
         owner_tag = @test.owner_tag
         owner_tag.owner_tests.delete(@test) if owner_tag
      end
      @test.save
      @test.reload
      flash[:info] = "Successfully updated #{ name }"
      if test_params[:modal]
         respond_to do |format|
            format.html
            redirect_back(fallback_location: root_path)
         end
      else
         render json: @test.edit_as_json
      end
   end

   def destroy
      @test.destroy
      flash[:info] = "Successfully deleted #{ @test.name }"
      head :no_content
   end

   private
   def set_test
      @test = Test.find(params[:id])
   end

   def test_params
      params.require(:test).permit(:name, :job_url, :parameterized)
   end
end
