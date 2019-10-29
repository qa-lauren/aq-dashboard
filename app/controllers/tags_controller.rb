class TagsController < ApplicationController
   before_action :set_tag, only: [:show, :update, :destroy]
   skip_before_action :disable_rotate, only: [:index, :owner]

   def index
      @tag_title="Applications"
      if @env_tag.name == 'dev'
         @tags = Tag.joins(:app_dev_builds).uniq
         #FATAL -- : [b986694d-fdea-4ed4-852b-30879267def6]
         #[b986694d-fdea-4ed4-852b-30879267def6] ActiveRecord::StatementInvalid (PG::UndefinedColumn: ERROR:  column builds.env does not exist
         #LINE 1: ..."builds" ON "builds"."test_id" = "tests"."id" AND "builds"."..
         # @tags = Tag.includes(:app_dev_builds).where(tag_type: "Application")

      elsif @env_tag.name == 'qa'
         @tags = Tag.joins(:app_qa_builds).uniq
         # @tags = Tag.includes(:app_qa_builds).where(tag_type: "Application")

      else
         @tags = Tag.joins(:app_prod_builds).uniq
         # @tags = Tag.includes(:app_prod_builds).where(tag_type: "Application")

      end
   end

   def owner
      @tag_title="Owners"
      if @env_tag.name == 'dev'
         @tags = Tag.joins(:owner_dev_builds).uniq
      elsif @env_tag.name == 'qa'
         @tags = Tag.joins(:owner_qa_builds).uniq
      else
         @tags = Tag.joins(:owner_prod_builds).uniq
      end
      respond_to do |format|
         format.html { render template: "tags/index" }
      end
   end

   def all
      @tag_title="All The Tests"
      @builds = Build.where(env:@env_tag.name)
      @app_names = Tag.where(tag_type: "Application").pluck(:name)
      @feature_names = Tag.where(tag_type: "Feature").pluck(:name)
      @owner_names = Tag.where(tag_type: "Owner").pluck(:name)

      respond_to do |format|
         format.html { render template: "tags/show" }
      end
   end

   def show
      @tag = Tag.find(params[:id])

         if @env_tag.name == 'dev'
            if @tag.tag_type=="Application"
               @builds = @tag.app_dev_builds
            elsif @tag.tag_type=="Owner"
               @builds = @tag.owner_dev_builds
            end
            @app_names = Tag.joins(:app_dev_builds).uniq.pluck(:name)
            @feature_names = Tag.joins(:feature_dev_builds).uniq.pluck(:name)
            @owner_names = Tag.joins(:owner_dev_builds).uniq.pluck(:name)
         elsif @env_tag.name == 'qa'
            if @tag.tag_type=="Application"
               @builds = @tag.app_qa_builds
            elsif @tag.tag_type=="Owner"
               @builds = @tag.owner_qa_builds
            end
            @app_names = Tag.joins(:app_qa_builds).uniq.pluck(:name)
            @feature_names = Tag.joins(:feature_qa_builds).uniq.pluck(:name)
            @owner_names = Tag.joins(:owner_qa_builds).uniq.pluck(:name)
         else
            if @tag.tag_type=="Application"
               @builds = @tag.app_prod_builds
            elsif @tag.tag_type=="Owner"
               @builds = @tag.owner_prod_builds
            end
            @app_names = Tag.joins(:app_prod_builds).uniq.pluck(:name)
            @feature_names = Tag.joins(:feature_prod_builds).uniq.pluck(:name)
            @owner_names = Tag.joins(:owner_prod_builds).uniq.pluck(:name)
         end
   end

   def create
      @tag = Tag.new(tag_params)
      if @tag.save
         flash[:info] = "Successfully added #{ @tag.name }"
         render json: @tag.edit_as_json
      else
         render json: @tag.errors, status: :unprocessable_entity
      end
   end

   def edit
      @tags = Tag.edit_all_as_json
   end

   def update
      if @tag.update(tag_params)
         flash[:info] = "#{ @tag.name } successfully updated"
         render json: @tag.edit_as_json
      else
         render json: @tag.errors, status: :unprocessable_entity
      end
   end

   def destroy
      @tag.destroy
      flash[:info] = "Successfully deleted #{ @tag.name }"
      head :no_content
   end

   private
   def set_tag
      @tag = Tag.find(params[:id])
   end

   def tag_params
      params.require(:tag).permit(:name, :tag_type)
   end
end
