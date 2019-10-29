module BuildsHelper
   def build_tag(test, tag_type)
      if tag_type == "Application"
         return test.app_tag.name if test.app_tag
      elsif tag_type == "Feature"
         return test.feature_tag.name if test.feature_tag
      else
         return test.owner_tag.name if test.owner_tag
      end
   end

   def build_tag_name(build, tag_type)
      if !build_tag(build, tag_type).nil?
         build_tag(build, tag_type).downcase.gsub(/[[:space:]]/, '')
      else
         return ""
      end
   end

   def show_build_status(test, env_tag)
      if !build.nil?
         if build.status=='progress'
            return "progress"
         else
            if build.status==''
               return "notbuilt"
            else
               if build.status=='progress'
                  return "progress"
               else
                  return build.status
               end
            end
         end
      else
         return "notbuilt"
      end
   end
end
