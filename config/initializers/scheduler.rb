require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton(:max_work_threads => 1)
scheduler.every '2m', :allow_overlapping => false, :timeout => '30s', :first => :now do

	if ENV['RAILS_ENV'] == 'production'
		begin
			puts "*****************************************************************************************************************RUFUS!!!!!!!!!!!!!!! WOOF WOOF WOOF"
			puts "****************************************************************************************************************************************************"
			Build.jenkins_update_all_tests
			puts "/end RUFUS!!!!!!!!!!!!!!! WOOF WOOF WOOF ***********************************************************************************************************"
			puts "****************************************************************************************************************************************************"
		rescue Rufus::Scheduler::TimeoutError
		  # ... that something got interrupted after 1 day
		  puts "TIME OUT"
		  scheduler = Rufus::Scheduler::singleton(:max_work_threads => 1)
		end
	end

end
