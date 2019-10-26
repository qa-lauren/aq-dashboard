class Build < ApplicationRecord
   validates_uniqueness_of :test_id, :scope => [:env], allow_blank: false
   belongs_to :dev_test, class_name: 'Test', optional: true
   belongs_to :qa_test, class_name: 'Test', optional: true
   belongs_to :prod_test, class_name: 'Test', optional: true
   has_many :notes, dependent: :destroy

   def self.get_job_url(test_name)
      "http://ci.powerreviews.io/job/qa-tests/job/#{test_name}/"
   end

   def self.get_jenkins_base_url
      "http://qabuildmonitor:fe855fdcecc278b8f7fef828fc565611@ci.powerreviews.io/job/qa-tests/"
   end

   def self.get_jenkins_formatted_url(url)
      return url.gsub("http://ci.powerreviews.io/job/qa-tests/","#{get_jenkins_base_url}")
   end

   def self.get_jenkins_job_url(job_name)
      "#{get_jenkins_base_url}/job/#{job_name}/"
   end

   def self.get_request_json(request_url)
      response=RestClient::Request.execute(:url => request_url, :method => :get, :verify_ssl => false)
      if !response.nil?
         return JSON.parse(response.body)
      end
   end

   def self.get_request_xml_json(request_url)
      return JSON.parse(Hash.from_xml(RestClient::Request.execute(:url => request_url, :method => :get, :verify_ssl => false)).to_json)
   end

   def self.get_jenkins_jobs_json(type)
      request_url="#{get_jenkins_base_url}view/#{type}/api/json?tree=jobs[name,url]"
      return get_request_json(request_url)["jobs"]
   end

   #stability and good duration
   # def self.calculate_stability(json, parameterized)
   def self.calculate_stability(json)
      begin
         results = json.map {|x| x["result"]}.compact
         results = results[0,20] if results.count >21
         success_count=results.count("SUCCESS")
         total_count =results.count
         stability= success_count/total_count.to_f*100
         return stability.round
      rescue
         return json["result"].to_i
      end
   end

   def self.calculate_ave_duration(json)
      begin
         durations = json.map {|a| a["duration"].to_i}.compact
         average = durations.inject{ |sum, el| sum+el}.to_f/durations.size
         return average.to_i
      rescue
         return json["duration"].to_i
      end
   end

   def jenkins_update(env) #(refresh)
      test = Test.where(id: test_id).first
      build = test.parameterized ? Build.jenkins_update_param_build(env, test) : Build.jenkins_update_nonparam_build(env, test)
      return build
      byebug
   end

   def jenkins_stop(job_url) #(refresh)
      url = job_url.gsub("http://ci.powerreviews.io/job/qa-tests/", "http://qabuildmonitor:fe855fdcecc278b8f7fef828fc565611@ci.powerreviews.io/job/qa-tests/")
      token_url = "#{url}/#{id}/stop"
      puts "stop token url= #{token_url}"
      response = RestClient::Request.execute(
         :method => :post,
         :url =>  token_url,
         :verify_ssl => false,
         :headers => {
            :content_type => :json,
            :accept => :json
            })
   end

   def self.get_jenkins_formatted_url(url)
      return url.gsub("http://ci.powerreviews.io/job/qa-tests/","#{get_jenkins_base_url}")
   end

   # NONPARAM ################################################################################################################
   def self.jenkins_update_nonparam_build(env, test)
      if !Build.find_by(env: env, test_id: test.id).nil?
         if env == 'dev'
            build = test.dev_build
         elsif env == 'qa'
            build = test.qa_build
         else
            build = test.prod_build
         end
      else
         build = Build.create(env: env, test_id: test.id)
         build.save
         build.reload
      end
      build_params = {}
      #get builds data from jenkins - stability and ave_duration params
      request_url = "#{get_jenkins_formatted_url(test.job_url)}api/json?tree=builds[result,duration]"
      json = get_request_json(request_url)
      if !json.nil?
         if !json["builds"].nil?
            if !json["builds"].empty?
               build_params[:stability]=calculate_stability(json["builds"])
               build_params[:ave_duration]=calculate_ave_duration(json["builds"])
            end
         end
      end
      #get build data from jenkins
      request_url = "#{get_jenkins_formatted_url(test.job_url)}api/json?tree=name,color,lastBuild[number,timestamp,duration],lastSuccessfulBuild[number,timestamp]"
      json = get_request_json(request_url)
      #status param
      if !json["color"].nil?
         if json["color"] == "blue"
            build_params[:status]="success"
         elsif json["color"] == "red"
            build_params[:status]="failure"
         elsif json["color"].include?("anime")
            build_params[:status]="progress"
         else
            build_params[:status]=json["color"]
         end
      end
      #last build data params
      if !json["lastBuild"].nil?
         build_params[:last_duration] = json["lastBuild"]["duration"]
         build_params[:last_number] = json["lastBuild"]["number"]
         build_params[:last_time] = Time.at(json["lastBuild"]["timestamp"]/1000).to_datetime
      end

      #last successful build data params
      if !json["lastSuccessfulBuild"].nil?
         build_params[:success_number] = json["lastSuccessfulBuild"]["number"]
         build_params[:success_time] = Time.at(json["lastSuccessfulBuild"]["timestamp"]/1000).to_datetime
         if build_params[:status]== "failure"
            if build_params[:success_time] > DateTime.now - 3.days
               build_params[:status]="failure-orange"
            end
         end
      end
      build.update(build_params)
      build.save
      build.reload
      return build
   end

   def self.jenkins_update_nonparam_tests(env)
      jobs_json = get_jenkins_jobs_json("nonparam-#{env}")
      jobs_json.each do |job|
         if !Test.where(name: job["name"]).nil?
            test = Test.where(name: job["name"])
         else
            test = Test.create(name: job["name"], job_url: job["url"], parameterized: false)
            test.save
            test.reload
         end
         jenkins_update_nonparam_build(env, test)
      end
   end
   # PARAM ################################################################################################################
   def self.jenkins_update_param_build(env, test)
      if !Build.find_by(env: env, test_id: test.id).nil?
         if env == 'dev'
            build = test.dev_build
         elsif env == 'qa'
            build = test.qa_build
         else
            build = test.prod_build
         end
      else
         build = Build.create(env: env, test_id: test.id)
         build.save
         build.reload
      end
      build_params = {}
      #get builds data from jenkins - stability and ave_duration params
      request_url = "#{get_jenkins_formatted_url(test.job_url)}api/json?tree=builds[result,duration]"
      json = get_request_json(request_url)
      if !json.nil?
         if !json["builds"].nil?
            if !json["builds"].empty?
               build_params[:stability]=calculate_stability(json["builds"])
               build_params[:ave_duration]=calculate_ave_duration(json["builds"])
            end
         end
      end
      #get build data from jenkins
      request_url="#{get_jenkins_formatted_url(job_url)}api/xml?tree=builds[result,duration,url,actions[parameters[name,value]]]&xpath=//build[action/parameter[value='#{env}']]&wrapper=builds"
      build_json=get_request_xml_json(request_url)
      if !build_json.nil?
         if !build_json["builds"].nil?
            if !build_json["builds"]["build"].nil?
               if !build_json["builds"]["build"].empty?
                  build_params[:stability]=calculate_stability(build_json["builds"]["build"])

                  begin
                     last_build_number_url=build_json["builds"]["build"][0]["url"]
                  rescue
                     last_build_number_url=build_json["builds"]["build"]["url"]
                  end
                  last_build_number_json=get_request_json("#{get_jenkins_formatted_url(last_build_number_url)}api/json?tree=result,timestamp,number,duration")
                  if !last_build_number_json.nil?
                     if !last_build_number_json["number"].nil?
                        build_params[:last_build_number] = last_build_number_json["number"]
                     end
                     if !last_build_number_json["timestamp"].nil?
                        build_params[:last_build_time] = Time.at(last_build_number_json["timestamp"]/1000).to_datetime
                     end
                     if !last_build_number_json["duration"].nil?
                        build_params[:last_duration] = last_build_number_json["duration"]
                     end
                     if !last_build_number_json["result"].nil?
                        build_params[:status]=last_build_number_json["result"].downcase
                     else
                        build_params[:status]="progress"
                     end
                  end
               end
            end
         end
         request_url="#{get_jenkins_formatted_url(job_url)}api/xml?tree=builds[result,duration,url,actions[parameters[name,value]]]&xpath=//build[action/parameter[value='#{env}'] and result/text()[1]='SUCCESS']&wrapper=builds"
         success_build_number_json=get_request_xml_json(request_url)
         if !success_build_number_json.nil?
            if !success_build_number_json["builds"].nil?
               if !build_json["builds"]["build"].nil?
                  if !build_json["builds"]["build"].empty?
                     build_params[:ave_duration]=calculate_ave_duration(success_build_number_json["builds"]["build"])
                     begin
                        begin
                           last_success_build_number_url=success_build_number_json["builds"]["build"][0]["url"]
                        rescue
                           last_success_build_number_url=success_build_number_json["builds"]["build"]["url"]
                        end
                        last_success_build_number_json=get_request_json("#{get_jenkins_formatted_url(last_success_build_number_url)}api/json?tree=result,timestamp,number,duration")
                        if !last_success_build_number_json.nil?
                           if !last_success_build_number_json["number"].nil?
                              build_params[:success_build_number] = last_success_build_number_json["number"]
                           end
                           if !last_success_build_number_json["timestamp"].nil?
                              build_params[:success_build_time] = Time.at(last_success_build_number_json["timestamp"]/1000).to_datetime
                           end
                           if build_params[:status] == "failure"
                              if !build_params[:success_build_time].nil?
                                 if build_params[:success_build_time] > DateTime.now - 3.days
                                    build_params[:status] = "failure-orange"
                                 end
                              end
                           end
                        end
                     rescue StandardError => e
                        puts e.message
                     end
                  end
               end
            end
         end
      end
      build.update(build_params)
      build.save
      build.reload
      byebug
      return build
   end

   def self.jenkins_update_param_tests(env)
      jobs_json = get_jenkins_jobs_json('param')
      jobs_json.each do |job|
         if !Test.where(name: job["name"]).nil?
            test = Test.where(name: job["name"])
         else
            test = Test.create(name: job["name"], job_url: job["url"], parameterized: true)
            test.save
            test.reload
         end
         jenkins_update_param_build(env, test)
      end
      jobs_json.each do |job|
         if !Test.where(name: job["name"]).nil?
            test = Test.where(name: job["name"])
         else
            test = Test.create(name: job["name"], job_url: job["url"], parameterized: true)
            test.save
            test.reload
         end
         jenkins_update_param_build(env, test)
      end
   end

   def self.jenkins_update_all_tests
      start = Time.now.getutc
      jenkins_update_nonparam_tests("dev")
      jenkins_update_nonparam_tests("qa")
      jenkins_update_nonparam_tests("prod")

      jenkins_update_param_tests("dev")
      jenkins_update_param_tests("qa")
      jenkins_update_param_tests("prod")
      stop = Time.now.getutc
      diff = Time.diff(start, stop)
      puts "TOTAL TIME ------- #{diff}"
   end
end
