
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


# Test.where("name like 'Cloud%'").each do |test|
#    a = Tag.find_by name: "Log Delivery"
#    a.app_tests << test
#    f = Tag.find_by name: "Friel"
#    f.owner_tests << test
# end
