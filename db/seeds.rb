# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "----> Seed Users"

users = [
  {email: "mmb@pykih.com", password: "indianmonsoon1234801", name: "Moiz Mansur"},
]


pykih_admin = User.new({email: "ab@pykih.com", password: "indianmonsoon1234801", name: "Amit Badheka", role: "admin"})
pykih_admin.skip_confirmation!
pykih_admin.is_active = true
pykih_admin.save

role  = 'admin'
is_active = true

users.each do |user|
  b = UserInvite.new(email: user[:email])
  b.sender = pykih_admin
  b.save

  a = User.new(email: user[:email], password: user[:password], confirmation_sent_at: Time.now,
               role: role, name: user[:name])
  a.skip_confirmation!
  a.is_active = true
  a.save
end

puts "----> Seed Countries"
# Read all tables from saved files and save to db
## Error logging file
File.open("airtable-data/errors-and-missing-data.txt", "w") do |ef|

  File.open("airtable-data/ref_countries.json", "r") do |f|
    countries = JSON.load(f.read)
    countries.each do |t|
      attrs = t["attrs"]
      country = RefCountry.new(name: attrs['name'], airtable_id: attrs['id'], is_active: true)
      country.creator = pykih_admin
      country.updater = pykih_admin
      country.save()
    end
  end

  puts "----> Seed Ref-Partners"
  File.open("airtable-data/ref_partners.json", "r") do |f|
    ef.write("\# Ref Partners\n\n")
    partners = JSON.load(f.read)
    partners.each do |t|
      attrs = t["attrs"]
      partner = RefPartner.new(name: attrs["name"], airtable_id: attrs["id"], is_active: true)
      partner.creator = pykih_admin
      partner.updater = pykih_admin
      if attrs["country"].present?
        begin
          partner.ref_country_id = RefCountry.where(airtable_id: attrs["country"]).first.id
          partner.save(validate: false)
        rescue
          ef.write("\t\# #{attrs['name']}, #{attrs['country']}\n")
        ensure
          next
        end
      end
      partner.save(validate: false)
    end
  end
  RefPartner.where(name: nil).delete_all

  puts "----> Seed Ref-Impacts"
  File.open("airtable-data/ref_impacts.json", "r") do |f|
    impacts = JSON.load(f.read)
    impacts.each do |t|
      attrs = t["attrs"]
      impact = RefImpact.new(name: attrs["name"], genre: attrs["genre"], airtable_id: attrs["id"], is_active: true)
      impact.creator = pykih_admin
      impact.updater = pykih_admin
      impact.save(validate: false)
    end
  end

  puts "----> Seed Ref-Targets"
  ### No errors in data entry
  File.open("airtable-data/ref_targets.json", "r") do |f|
    targets = JSON.load(f.read)
    targets.each do |t|
      attrs = t["attrs"]
      target = RefTarget.new(name: attrs["name"], airtable_id: attrs["id"], is_active: true)
      target.save(validate: false)
    end
  end

  puts "----> Seed Ref-Users"
  ### No errors in data entry
  File.open("airtable-data/ref_users.json", "r") do |f|
    users = JSON.load(f.read)
    users.each do |u|
      attrs = u["attrs"]
      user = User.new(email: attrs["email"],
                      name: attrs["name"],
                      role: attrs["role"],
                      airtable_id: attrs["id"])
      user.skip_confirmation!
      if attrs["email"] == "ritvvij.parrikh@icfj.com"
        user.password = "indianmonsoon1234801"
        user.is_active = true
      elsif attrs["role"] == "admin"
        user.password = "iamanadmin"
        user.is_active = true
      else
        user.password = "iamafellow"
        user.is_active = true
      end
      user.save
    end
  end

  ## Other tables
  # puts "----> Seed Channel for impact monitor"

  # no_of_channels = ImpactMonitorApi.get_all_channels['channels'].count
  # new_channel = ImpactMonitorApi.add_channel("Channel-#{no_of_channels + 1}")
  # channel_id = ImpactMonitorApi.get_channel_overview(new_channel["uniqueid"])["channel_id"]
  # a = Channel.create(name: new_channel['name'],
  #                    unique_id_token: new_channel['uniqueid'],
  #                    is_active: true,
  #                    channel_id: channel_id)

  puts "----> Seed Digital Assets"

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
      digital_asset.skip_callbacks = true
      digital_asset.save(validate: false)
      # if digital_asset.item_id.present?
      #   puts "#{digital_asset.item_id}, #{digital_asset.id}"
      # else
      #   puts "Not added, #{digital_asset.id}"
      # end
    end
  end

  puts "----> Seed Projects"
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

  puts "----> Seed Projects-Users"
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

  puts "----> Seed Projects-RefPartners"
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

  puts "----> Seed Events"
  ### No errors in data entry
  File.open("airtable-data/events.json", "r") do |f|
    events = JSON.load(f.read)
    events.each do |p|
      attrs = p['attrs']
      event = Event.new(description: attrs["description"],
                        event_date: attrs['date'],
                        notes: attrs['additional_notes'],
                        airtable_id: attrs['id'])
      event.event_ref_impacts_list = ""
      event.event_projects_list = ""
      event.event_users_list = ""
      event.event_digital_assets_list = ""
      event.event_ref_partners_list = ""
      event.event_ref_countries_list = ""

      if attrs["needs_review"] == true
        event.is_review_required = true
      else
        event.is_review_required = false
      end

      if attrs["confidential"] == true
        event.is_confidential = true
      else
        event.is_confidential = false
      end
      event.save
    end
  end

  puts "----> Seed Event-RefProjects"
  File.open("airtable-data/events.json", "r") do |f|
    events = JSON.load(f.read)
    ef.write("\# Event Ref Projects\n\n")
    events.each do |p|
      attrs = p['attrs']
      if attrs['projects'].present?
        attrs['projects'].each do |p|
          begin
            event_project = EventProject.new(event_id: Event.where(airtable_id: attrs["id"]).first.id,
                                                 project_id: Project.where(airtable_id: p).first.id)
            event_project.save
          rescue
            ef.write("\t\# Event ID - #{attrs['id']}, #{p}\n")
          ensure
            next
          end
        end
      end
    end
  end

  puts "----> Seed Event-RefImpacts"
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

  puts "----> Seed Event-Users"
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

  puts "----> Seed Event-Digital Assets"
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

  puts "----> Seed Event-Ref Country"
  File.open("airtable-data/events.json", "r") do |f|
    events = JSON.load(f.read)
    ef.write("\# Event Ref Countries\n\n")
    events.each do |p|
      attrs = p['attrs']
      if attrs["ref_countries"].present?
        attrs["ref_countries"].each do |p|
          begin
            event_ref_country = EventRefCountry.new(event_id: Event.where(airtable_id: attrs["id"]).first.id,
                                                    ref_country_id: RefCountry.where(airtable_id: p).first.id)
            event_ref_country.save
          rescue
            ef.write("\t\# Event ID - #{attrs['id']}, #{p}\n")
          ensure
            next
          end
        end
      end
    end
  end

  puts "----> Seed Event-Ref Partner"
  File.open("airtable-data/events.json", "r") do |f|
    events = JSON.load(f.read)
    ef.write("\# Event Ref Partners\n\n")
    events.each do |p|
      attrs = p['attrs']
      if attrs["partner(s)"].present?
        attrs["partner(s)"].each do |p|
          begin
            event_ref_partner = EventRefPartner.new(event_id: Event.where(airtable_id: attrs["id"]).first.id,
                                                    ref_partner_id: RefPartner.where(airtable_id: p).first.id)
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
end

puts "----> Get items from Impact Monitor"
begin
  token = Channel.active.first.unique_token_id
rescue NoMethodError
  puts "No active channel exists"
else
  ## Get channel data from impactmonitor
  File.open("airtable-data/impact-monitor-data/channel-data.json", "w") do |f|
    f.write(JSON.pretty_generate(ImpactMonitorApi.list_channel_items(token).as_json))
  end

  puts "----> Assign item_ids to existing digital assets"
  ## Sets item_ids to existing digital assets
  items = nil
  File.open("airtable-data/impact-monitor-data/channel-data.json", "r") do |f|
    data = JSON.parse(f.read)
    items = data["items"]
  end

  items.each do |item|
    da = DigitalAsset.where(asset: item["item_string"]).first
    if da.present?
      da.update_columns(item_id: item["monitored_item_id"].to_i,
                        tracked: true)
    end
  end
end


# puts "----> Seed Trackable Metrics to digital assets"
# DigitalAsset.find_each(&:save)

# puts "\n\n----> Reverting migration add airtable ids to all tables"

# %x( rake db:migrate:down VERSION=20170725101340 )

puts "All data from Airtable data seeded.\nPlease check the error log in /airtable-data/errors-and-missing-data.txt"

