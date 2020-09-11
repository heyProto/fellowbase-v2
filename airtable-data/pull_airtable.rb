# Get all tables. Using copy for moiz only. 24/07/17. https://airtable.com/tbluJVyKAOi7t5wpo/viwSv9EZcPkkAfDtW
## Ref tables.
File.open("airtable-data/ref_partners.json", "w") do |f|
  f.write(JSON.pretty_generate(AirtableApi.get_table("ref_partners").as_json))
end

File.open("airtable-data/ref_impacts.json", "w") do |f|
  f.write(JSON.pretty_generate(AirtableApi.get_table("ref_impacts").as_json))
end

File.open("airtable-data/ref_targets.json", "w") do |f|
  f.write(JSON.pretty_generate(AirtableApi.get_table("ref_Targets/Milestones-IndiaOnly").as_json))
end

File.open("airtable-data/ref_users.json", "w") do |f|
  f.write(JSON.pretty_generate(AirtableApi.get_table("ref_users").as_json))
end

File.open("airtable-data/ref_countries.json", "w") do |f|
  f.write(JSON.pretty_generate(AirtableApi.get_table("ref_countries").as_json))
end

## Other tables
File.open("airtable-data/projects.json", "w") do |f|
  f.write(JSON.pretty_generate(AirtableApi.get_table("projects").as_json))
end

File.open("airtable-data/events.json", "w") do |f|
  f.write(JSON.pretty_generate(AirtableApi.get_table("events").as_json))
end

File.open("airtable-data/digital_assets.json", "w") do |f|
  f.write(JSON.pretty_generate(AirtableApi.get_table("digital_assets").as_json))
end


##################################################################
#
#
# Use the below code only in seeds. Use above code only if new 
# data to be pulled
#
#
##################################################################

# Read all tables from saved files and save to db

pykih_admin = User.where(email: "ab@pykih.com").first
File.open("airtable-data/errors-and-missing-data.txt", "w") do |ef|

  File.open("airtable-data/ref_countries.json", "r") do |f|
    countries = JSON.load(f.read)
    countries.each do |t|
      attrs = t["attrs"]
      country = RefCountry.new(name: attrs['name'], airtable_id: attrs['id'])
      country.creator = pykih_admin
      country.updater = pykih_admin
      country.save()
    end
  end


File.open("airtable-data/ref_partners.json", "r") do |f|
  ef.write("\# Ref Partners\n\n")
  partners = JSON.load(f.read)
  partners.each do |t|
    attrs = t["attrs"]
    partner = RefPartner.new(name: attrs["name"], airtable_id: attrs["id"])
    partner.creator = pykih_admin
    partner.updater = pykih_admin
    if attrs["country"] != nil
      begin
        partner.ref_country_id = RefCountry.where(airtable_id: attrs["country"]).first.id
      rescue
        ef.write("\t\# #{attrs['name']}, #{attrs['country']}\n")
      ensure
        next
      end
    end
    partner.save(validate: false)
  end
end

File.open("airtable-data/ref_impacts.json", "r") do |f|
  impacts = JSON.load(f.read)
  impacts.each do |t|
    attrs = t["attrs"]
    impact = RefImpact.new(name: attrs["name"], genre: attrs["genre"], airtable_id: attrs["id"])
    impact.creator = pykih_admin
    impact.updater = pykih_admin
    impact.save(validate: false)
  end
end

### No errors in data entry
File.open("airtable-data/ref_targets.json", "r") do |f|
  targets = JSON.load(f.read)
  targets.each do |t|
    attrs = t["attrs"]
    target = RefTarget.new(name: attrs["name"], airtable_id: attrs["id"])
    target.save(validate: false)
  end
end

### No errors in data entry
File.open("airtable-data/ref_users.json", "r") do |f|
  users = JSON.load(f.read)
  users.each do |u|
    attrs = u["attrs"]
    user = User.new(email: attrs["email"],
                    name: attrs["name"],
                    role: attrs["role"],
                    is_active: true,
                    airtable_id: attrs["id"])
    user.skip_confirmation!
    if attrs["role"] = "admin"
      user.password = "indianmonsoon1234801"
    else
      user.password = "iamafellow"
    end
    user.save
  end
end


## Other tables

### No errors in data entry
File.open("airtable-data/digital_assets.json", "r") do |f|
  digital_assets = JSON.load(f.read)
  digital_assets.each do |u|
    attrs = u["attrs"]
    digital_asset = DigitalAsset.new(asset: attrs["asset"],
                                     publish_date: attrs["date"],
                                     headline: attrs["headline"],
                                     airtable_id: attrs["id"],
                                     publication: attrs["publication"],
                                     post_type: attrs["post_type"])
    digital_asset.save(validate: false)
  end
end

File.open("airtable-data/projects.json", "r") do |f|
  projects = JSON.load(f.read)
  projects.each do |p|
    attrs = p['attrs']
    project = Project.new(name: attrs["name"], airtable_id: attrs["id"])
    project.name_list = ''
    project.partner_list = ''
    project.save
  end
end


File.open("airtable-data/projects.json", "r") do |f|
  projects = JSON.load(f.read)
  ef.write("\# Project Users\n\n")
  projects.each do |p|
    attrs = p['attrs']
    if attrs['fellows'].present?
      attrs['fellows'].each do |fellow|
        begin
        project_user = ProjectUser.new(user_id: User.where(airtable_id: fellow).first.id, project_id: Project.where(airtable_id: attrs["id"]).first.id)
        project_user.save
        rescue
          ef.write("\t\# Project ID - #{attrs['id']}, #{p}\n")
        ensure
          next
        end
      end
    end
  end
end

File.open("airtable-data/projects.json", "r") do |f|
  projects = JSON.load(f.read)
  ef.write("\# Project Ref Partners\n\n")
  projects.each do |p|
    attrs = p['attrs']
    if attrs["partners_(ref_partners)"].present?
      attrs["partners_(ref_partners)"].each do |p|
        begin
          project_ref_partner = ProjectRefPartner.new(ref_partner_id: RefPartner.where(airtable_id: p).first.id, project_id: Project.where(airtable_id: attrs["id"]).first.id)
          project_ref_partner.save
        rescue
          ef.write("\t\# Project ID - #{attrs['id']}, #{p}\n")
        ensure
          next
        end
      end
    end
  end
end

### No errors in data entry
File.open("airtable-data/events.json", "r") do |f|
  events = JSON.load(f.read)
  events.each do |p|
    attrs = p['attrs']
    event = Event.new(description: attrs["description"],
                        event_date: attrs['date'],
                        notes: attrs['additional_notes'],
                        airtable_id: attrs['id'])
    event.event_ref_impacts = ""
    event.event_projects = ""
    event.event_users = ""
    event.event_digital_assets = ""

    if attrs["needs_review"] == "true"
      event.is_review_required = true
    else
      event.is_review_required = false
    end

    if attrs["confidential"] == "true"
      event.is_confidential = true
    else
      event.is_confidential = false
    end
    event.save
  end
end


File.open("airtable-data/events.json", "r") do |f|
  events = JSON.load(f.read)
  ef.write("\# Event Ref Partners\n\n")
  events.each do |p|
    attrs = p['attrs']
    if attrs['projects'].present?
      attrs['projects'].each do |p|
        begin
          event_ref_partner = EventProject.new(event_id: Event.where(airtable_id: attrs["id"]).first.id,
                                                  project_id: Project.where(airtable_id: p).first.id)
          event_ref_partner.save
        rescue
          ef.write("\t\# Event ID - #{attrs['id']}, #{p}\n")
        ensure
          next
        end
      end
    end
  end
end

File.open("airtable-data/events.json", "r") do |f|
  events = JSON.load(f.read)
  ef.write("\# Event Impact Types\n\n")
  events.each do |p|
    attrs = p['attrs']
    if attrs["ref_impact_types"].present?
      attrs["ref_impact_types"].each do |p|
        begin
          event_ref_impact = EventRefImpact.new(event_id: Event.where(airtable_id: attrs["id"]).first.id,
                                                ref_impact_id: RefImpact.where(airtable_id: p).first.id)
          event_ref_impact.save
        rescue
          ef.write("\t\# Event ID - #{attrs['id']}, #{p}\n")
        ensure
          next
        end
      end
    end
  end
end

File.open("airtable-data/events.json", "r") do |f|
  events = JSON.load(f.read)
  ef.write("\# Event Users\n\n")
  events.each do |p|
    attrs = p['attrs']
    if attrs["icfj_knight_fellow_(point_person)"].present?
      attrs["icfj_knight_fellow_(point_person)"].each do |p|
        begin
          event_user = EventUser.new(event_id: Event.where(airtable_id: attrs["id"]).first.id,
                                     user_id: User.where(airtable_id: p).first.id)
          event_user.save
        rescue
          ef.write("\t\# Event ID - #{attrs['id']}, #{p}\n")
        ensure
          next
        end
      end
    end
  end
end

File.open("airtable-data/events.json", "r") do |f|
  events = JSON.load(f.read)
  ef.write("\# Event Digital Asset\n\n")
  events.each do |p|
    attrs = p['attrs']
    if attrs["link"].present?
      attrs["link"].each do |p|
        begin
          event_digital_asset = EventDigitalAsset.new(event_id: Event.where(airtable_id: attrs["id"]).first.id,
                                                      digital_asset_id: DigitalAsset.where(airtable_id: p).first.id)
          event_digital_asset.save
        rescue
          ef.write("\t\# Event ID - #{attrs['id']}, #{p}\n")
        ensure
          next
        end
      end
    end
  end
end
end
