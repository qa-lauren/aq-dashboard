module TagsHelper

   def all_tests_count(env_tag)
      if env_tag.name == 'dev'
         Test.includes(:dev_build).count
      elsif env_tag.name == 'qa'
         Test.includes(:qa_build).count
      else
         Test.includes(:prod_build).count
      end
   end

   def all_success_tests_count(env_tag)
      if env_tag.name == 'dev'
         # Test.includes(:dev_build).where(dev_build: {status: "success"}).pluck(:id).count

         Test.includes(:dev_build).where(dev_build: {status: "success"}).count

      elsif env_tag.name == 'qa'
         Test.includes(:qa_build).count
      else
         Test.includes(:prod_build).count
      end

      return Test.includes(:builds).where(builds: {environment_tag_id:env_tag.id, status: "success"}).pluck(:id).count if Test.includes(:builds).where(builds: {environment_tag_id:env_tag.id, status: "success"})
   end

   def tag_tests_by_env(tag, env_tag)

      if env_tag.name == 'dev'
         if tag.tag_type == "Application"
            return Test.includes(:dev_build).where(app_tag_id: tag.id)
         elsif tag.tag_type == "Owner"
            return Test.includes(:dev_build).where(owner_tag_id: tag.id)
         end
      elsif env_tag.name == 'qa'
         if tag.tag_type == "Application"
            return Test.includes(:qa_build).where(app_tag_id: tag.id)
         elsif tag.tag_type == "Owner"
            return Test.includes(:qa_build).where(owner_tag_id: tag.id)
         end
      else
         if tag.tag_type == "Application"
            return Test.includes(:prod_build).where(app_tag_id: tag.id)
         elsif tag.tag_type == "Owner"
            return Test.includes(:prod_build).where(owner_tag_id: tag.id)
         end
      end

      return nil
   end

   def tag_tests_total_count(tag, env_tag)
      tag_tests_by_env(tag,env_tag).pluck(:id).count
   end

   def tag_tests_count(tag, env_tag, status)
      if env_tag.name == 'dev'
         # byebug
         if tag.tag_type == "Application"
            test_ids = Test.includes(:dev_build).where(app_tag_id: tag.id).pluck(:id)
            Build.where(status: status).count

            # return Test.includes(:dev_build).where(dev_build: { status: status }).where(app_tag_id: tag.id).count
         elsif tag.tag_type == "Owner"
            test_ids = Test.includes(:dev_build).where(owner_tag_id: tag.id).pluck(:id)
            Build.where(status: status).count
         end
      elsif env_tag.name == 'qa'
         if tag.tag_type == "Application"
            test_ids = Test.includes(:qa_build).where(app_tag_id: tag.id).pluck(:id)
            Build.where(status: status).count

            # return Test.includes(:dev_build).where(dev_build: { status: status }).where(app_tag_id: tag.id).count
         elsif tag.tag_type == "Owner"
            test_ids = Test.includes(:qa_build).where(owner_tag_id: tag.id).pluck(:id)
            Build.where(status: status).count
         end
      else
         if tag.tag_type == "Application"
            test_ids = Test.includes(:prod_build).where(app_tag_id: tag.id).pluck(:id)
            Build.where(status: status).count

            # return Test.includes(:dev_build).where(dev_build: { status: status }).where(app_tag_id: tag.id).count
         elsif tag.tag_type == "Owner"
            test_ids = Test.includes(:prod_build).where(owner_tag_id: tag.id).pluck(:id)
            Build.where(status: status).count
         end
      end

      return 0
   end

   ######
   def tag_failed_tests_with_success_null_count(tag, env_tag)
      tag_tests_stability_ids(tag, env_tag).count
   end
   def tag_tests_stability_ids(tag, env_tag)
      ids = tag_tests_by_env(tag, env_tag).pluck(:id)
      failed_ids = Build.where(id:ids).where("status = 'failure' and success_build_time is null").pluck(:id)
   end
   def tag_tests_stability_ids(tag, env_tag)
      ids = tag_tests_by_env(tag, env_tag).pluck(:id)
      return Build.where(id:ids).where("stability < 75").order(stability: :asc).pluck(:id)
   end
   def tag_tests_stability(tag, env_tag)
      stability_ids = tag_tests_stability_ids(tag, env_tag)
      return Test.where(id:stability_ids).select(:name, :job_url)
   end
   def tag_failed_tests(tag, env_tag)
      ids = tag_tests_by_env(tag, env_tag).pluck(:id)
      failed_ids = Build.where(id:ids).where("status = 'failure' and success_build_time is not null").order(success_build_time: :desc).pluck(:test_id)
      return Test.where(id:failed_ids).select(:name, :job_url)
   end
   def tag_failed_tests_with_success_null(tag, env_tag)
      ids = tag_tests_by_env(tag, env_tag).pluck(:id)
      failed_ids = Build.where(id:ids).where("status = 'failure' and success_build_time is null").pluck(:test_id)
      return Test.where(id:failed_ids).select(:name, :job_url)
   end
   def tag_failed_tests_with_success_null_count(tag, env_tag)
      ids = tag_tests_by_env(tag, env_tag).pluck(:id)
      return Build.where(id:ids).where("status = 'failure' and success_build_time is null").pluck(:id).count
   end
end
