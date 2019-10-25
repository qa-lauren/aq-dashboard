require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton(:max_work_threads => 1)
scheduler.every '2m', :allow_overlapping => false, :timeout => '2m', :first => :now do

	if ENV['RAILS_ENV'] == 'production'
		begin
			puts "*****************************************************************************************************************RUFUS!!!!!!!!!!!!!!! WOOF WOOF WOOF"
			puts "****************************************************************************************************************************************************"
			Test.update_jenkins_build_data_all
			puts "/end RUFUS!!!!!!!!!!!!!!! WOOF WOOF WOOF ***********************************************************************************************************"
			puts "****************************************************************************************************************************************************"
		rescue Rufus::Scheduler::TimeoutError
		  # ... that something got interrupted after 1 day
		  puts "TIME OUT"
		end
	end
   
end
