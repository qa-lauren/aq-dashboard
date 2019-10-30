module TestsHelper
   def default_app(test)
      test.app_tag.present? ? test.app_tag.id : 0
   end

   def default_feature(test)
      test.feature_tag.present? ? test.feature_tag.id : 0
   end

   def default_owner(test)
      test.owner_tag.present? ? test.owner_tag.id : 0
   end

   # def show_status(test, env_tag)
   #    build = Build.find_by_env(test, env_tag)
   #    if !build.nil?
   #       if build.status=='progress'
   #          return "in-progress"
   #       else
   #          if build.status==''
   #             return "notbuilt"
   #          else
   #             if build.status=='progress'
   #                return build.status
   #             else
   #                return build.status
   #             end
   #          end
   #       end
   #    else
   #       return "notbuilt"
   #    end
   # end

   def show_tag_name(test, tag_type)
      if tag_type == "Application"
         id = test.app_tag_id if test.app_tag_id
      elsif tag_type == "Feature"
         id = test.feature_tag_id if test.feature_tag_id
      else
         id = test.owner_tag_id if test.owner_tag_id
      end
      if !id.nil?
         return Tag.find(id).name if Tag.find(id)
      end
   end

   def show_tag(test, tag_type)
      if !show_tag_name(test, tag_type).nil?
         show_tag_name(test, tag_type).downcase.gsub(/[[:space:]]/, '')
      else
         return ""
      end
   end
end
