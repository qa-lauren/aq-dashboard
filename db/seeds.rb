# EnvironmentTag.create(name: "dev")
# EnvironmentTag.create(name: "qa")
# EnvironmentTag.create(name: "prod")
#
# ###### APPS ######
# ##########################################################################################################
# Tag.create(name: "Analytics - ETL", tag_type: "Application")
# Tag.create(name: "Content Publication", tag_type: "Application")
# Tag.create(name: "Core Data Services", tag_type: "Application")
# Tag.create(name: "DashJr", tag_type: "Application")
# Tag.create(name: "Engagement Services", tag_type: "Application")
# Tag.create(name: "Journey-IQ", tag_type: "Application")
# Tag.create(name: "Log Delivery", tag_type: "Application")
# Tag.create(name: "Moderation Alerts", tag_type: "Application")
# Tag.create(name: "Moderation Services", tag_type: "Application")
# Tag.create(name: "Product Services", tag_type: "Application")
# Tag.create(name: "Pufferfish Services", tag_type: "Application")
# Tag.create(name: "Read Services", tag_type: "Application")
# Tag.create(name: "Reporting", tag_type: "Application")
# Tag.create(name: "Shared Services", tag_type: "Application")
# Tag.create(name: "Write Services", tag_type: "Application")
# Tag.create(name: "Write Services Batch", tag_type: "Application")
# Tag.create(name: "UI - Analytics Application", tag_type: "Application")
# Tag.create(name: "UI - Collect 4", tag_type: "Application")
# Tag.create(name: "UI - Display 4", tag_type: "Application")
# Tag.create(name: "UI - Legacy", tag_type: "Application")
# Tag.create(name: "UI - Moderation", tag_type: "Application")
# Tag.create(name: "UI - Portal", tag_type: "Application")
# Tag.create(name: "UI - Tools", tag_type: "Application")
#
# ###### FEATURE ######
# ##########################################################################################################
# Tag.create(name: "Brand Engage", tag_type: "Feature")
# Tag.create(name: "Client Moderation", tag_type: "Feature")
# Tag.create(name: "Extranet", tag_type: "Feature")
# Tag.create(name: "Feedless", tag_type: "Feature")
# Tag.create(name: "FUE", tag_type: "Feature")
# Tag.create(name: "Inbound Syndication", tag_type: "Feature")
# Tag.create(name: "IntelligentCollect", tag_type: "Feature")
# Tag.create(name: "Media First", tag_type: "Feature")
# Tag.create(name: "Media First Syndication", tag_type: "Feature")
# Tag.create(name: "Order Feed", tag_type: "Feature")
# Tag.create(name: "OTF RYP", tag_type: "Feature")
# Tag.create(name: "Product Answer", tag_type: "Feature")
# Tag.create(name: "Progressive RYP", tag_type: "Feature")
# Tag.create(name: "Pwr Moderation", tag_type: "Feature")
# Tag.create(name: "Q&A Syndication", tag_type: "Feature")
# Tag.create(name: "Review b2b", tag_type: "Feature")
# Tag.create(name: "Review Display", tag_type: "Feature")
# Tag.create(name: "Review Import", tag_type: "Feature")
# Tag.create(name: "Review Syndication", tag_type: "Feature")
# Tag.create(name: "RYP", tag_type: "Feature")
# Tag.create(name: "Search", tag_type: "Feature")
# Tag.create(name: "Social Collection", tag_type: "Feature")
# Tag.create(name: "UGC Migrator", tag_type: "Feature")
# Tag.create(name: "UGC Editing", tag_type: "Feature")
# Tag.create(name: "WAR", tag_type: "Feature")
# Tag.create(name: "Wyng", tag_type: "Feature")
#
# ###### FILTER ######
# ##########################################################################################################
# Tag.create(name: "Ben", tag_type: "Owner")
# Tag.create(name: "Friel", tag_type: "Owner")
# Tag.create(name: "Greg", tag_type: "Owner")
# Tag.create(name: "JJ", tag_type: "Owner")
# Tag.create(name: "John", tag_type: "Owner")
# Tag.create(name: "Lauren", tag_type: "Owner")
# Tag.create(name: "Darianna", tag_type: "Owner")
# Tag.create(name: "Tylor", tag_type: "Owner")

# Build.jenkins_update_all_tests


Test.where("name like 'ModerationAlerts%'").each do |test|
	a = Tag.find_by name: "ModerationAlerts"
	a.app_tests << test
   a = Tag.find_by name: "Client Moderation"
   a.feature_tests << test
	e = Tag.find_by name: "Lauren"
	e.owner_tests << test

end
Test.where("name like 'Pwr%'").each do |test|
	a = Tag.find_by name: "UI - Moderation"
	a.app_tests << test
   # a = Tag.find_by name: "Pwr Moderation"
   # a.feature_tests << test
	e = Tag.find_by name: "Ben"
	e.owner_tests << test

end
Test.where("name like '%Analytics%'").each do |test|
	a = Tag.find_by name: "Reporting"
	a.app_tests << test
	e = Tag.find_by name: "Greg"
	e.owner_tests << test

end

Test.where("name like 'Shopify%'").each do |test|
	a = Tag.find_by name: "UI - Portal"
	a.app_tests << test
	e = Tag.find_by name: "Lauren"
	e.owner_tests << test

end

Test.where("name like 'z-%'").each do |test|
	f = Tag.find_by name: "Friel"
	f.owner_tests << test
end

Test.where("name like 'dev-%'").each do |test|

   f = Tag.find_by name: "Friel"
   f.owner_tests << test
end

Test.where("name like '%cdm_%'").each do |test|
	a = Tag.find_by name: "Moderation Services"
	a.app_tests << test
	f = Tag.find_by name: "Friel"
	f.owner_tests << test
end
Test.where("name like 'Brand-Engage-%'").each do |test|
	a = Tag.find_by name: "Moderation Services"
	a.app_tests << test
	e = Tag.find_by name: "Brand Engage"
	e.feature_tests << test
	f = Tag.find_by name: "JJ"
	f.owner_tests << test
end

Test.where("name like 'Brand-Engage_%'").each do |test|
	a = Tag.find_by name: "UI - Moderation"
	a.app_tests << test
	e = Tag.find_by name: "Brand Engage"
	e.feature_tests << test
	f = Tag.find_by name: "Lauren"
	f.owner_tests << test
end
Test.where("name like 'C4%'").each do |test|
	a = Tag.find_by name: "UI - Collect 4"
	a.app_tests << test
	f = Tag.find_by name: "John"
	f.owner_tests << test
end
Test.where("name like 'D4%'").each do |test|
	a = Tag.find_by name: "UI - Display 4"
	a.app_tests << test
	e = Tag.find_by name: "Review Display"
	e.feature_tests << test
	f = Tag.find_by name: "John"
	f.owner_tests << test
end
Test.where("name like 'Display-%'").each do |test|
	a = Tag.find_by name: "UI - Display 4"
	a.app_tests << test
	e = Tag.find_by name: "Review Display"
	e.feature_tests << test
	f = Tag.find_by name: "John"
	f.owner_tests << test
end
Test.where("name like 'Content-Publication%'").each do |test|
	a = Tag.find_by name: "Content Publication"
	a.app_tests << test
	f = Tag.find_by name: "JJ"
	f.owner_tests << test
end

Test.where("name like 'Core-Services%'").each do |test|
	a = Tag.find_by name: "Core Data Services"
	a.app_tests << test
	f = Tag.find_by name: "JJ"
	f.owner_tests << test
end


   Test.where("name like 'Engagement-Services%'").each do |test|
   a = Tag.find_by name: "Engagement Services"
   a.app_tests << test
   f = Tag.find_by name: "JJ"
   f.owner_tests << test
end
Test.where("name like 'Moderation-Services%'").each do |test|
	a = Tag.find_by name: "Moderation Services"
	a.app_tests << test
	f = Tag.find_by name: "JJ"
	f.owner_tests << test
end

Test.where("name like 'Product-Services%'").each do |test|
   a = Tag.find_by name: "Product Services"
   a.app_tests << test
   f = Tag.find_by name: "JJ"
   f.owner_tests << test
end


   Test.where("name like 'Shared-Services%'").each do |test|
   a = Tag.find_by name: "Shared Services"
   a.app_tests << test
   f = Tag.find_by name: "Friel"
   f.owner_tests << test
end


   Test.where("name like 'Write-Services%'").each do |test|
   a = Tag.find_by name: "Write Services"
   a.app_tests << test
   f = Tag.find_by name: "Friel"
   f.owner_tests << test
end


   Test.where("name like 'Tools%'").each do |test|
   a = Tag.find_by name: "UI - Tools"
   a.app_tests << test
   f = Tag.find_by name: "Lauren"
   f.owner_tests << test
end

      Test.where("name like 'Log-Delivery%'").each do |test|
   a = Tag.find_by name: "Log Delivery"
   a.app_tests << test
   f = Tag.find_by name: "Friel"
   f.owner_tests << test
end

Test.where("name like 'CDM%'").each do |test|
	a = Tag.find_by name: "UI - Moderation"
	a.app_tests << test
	e = Tag.find_by name: "Client Moderation"
	e.feature_tests << test
	f = Tag.find_by name: "Lauren"
	f.owner_tests << test
end

Test.where("name like 'Extranet%'").each do |test|
	a = Tag.find_by name: "Pufferfish Services"
	a.app_tests << test
	e = Tag.find_by name: "FUE"
	e.feature_tests << test
	e = Tag.find_by name: "RSD"
	e.owner_tests << test

end


Test.where("name like 'Extranet-%'").each do |test|
	a = Tag.find_by name: "Pufferfish Services"
	a.app_tests << test
	e = Tag.find_by name: "FUE"
	e.feature_tests << test
	e = Tag.find_by name: "RSD"
	e.owner_tests << test
end
Test.where("name like 'Product-Services%'").each do |test|
	a = Tag.find_by name: "Product Services"
	a.app_tests << test
	e = Tag.find_by name: "JJ"
	e.owner_tests << test

end

# Test.where("name like '%Reporting%'").each do |test|
# 	a = Tag.find_by name: "Reporting"
# 	a.app_tests << test
# 	e = Tag.find_by name: "Greg"
# 	e.owner_tests << test

# end

# Test.where("name like 'Read-Services%'").each do |test|
# 	a = Tag.find_by name: "Read Services"
# 	a.app_tests << test
# 	e = Tag.find_by name: "Friel"
# 	e.owner_tests << test

# end

# Test.where("name like '%writeservices%'").each do |test|
# 	a = Tag.find_by name: "Write Services"
# 	a.app_tests << test
# 	f = Tag.find_by name: "Friel"
# 	f.owner_tests << test
# end
# Test.where("name like '%log-delivery%'").each do |test|
# 	a = Tag.find_by name: "Log Delivery"
# 	a.app_tests << test
# 	e = Tag.find_by name: "Order Feed"
# 	e.feature_tests << test
# 	f = Tag.find_by name: "Friel"
# 	f.owner_tests << test
# end
