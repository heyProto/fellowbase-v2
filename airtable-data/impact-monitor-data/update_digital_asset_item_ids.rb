# Run this code in the console

## Get channel data from impactmonitor
File.open("airtable-data/impact-monitor-data/channel-data.json", "w") do |f|
  f.write(JSON.pretty_generate(ImpactMonitorApi.list_channel_items(Channel.active.first.unique_token_id).as_json))
end

## Sets item_ids to existing digital assets
items = nil
File.open("airtable-data/impact-monitor-data/channel-data.json", "r") do |f|
  data = JSON.parse(f.read)
  items = data["items"]
end

items.each do |item|
  da = DigitalAsset.where(asset: item["item_string"]).first
  if da.present?
    da.update_columns(item_id: item["monitored_item_id"].to_i)
  end
end
