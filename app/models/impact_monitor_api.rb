class ImpactMonitorApi
  IMPACT_MONITOR_URL = "http://impactmonitor.net/app/api"
  class << self

    # Channel methods
    # Methods for getting all channels,
    # adding an item to monitor to a channel
    # list all items in a particular channel
    # add a channel
    #
    # Item methods
    # Update an item
    # overview an item
    # get tweets with the item
    # get social shares for an item
    # delete an item


    # Channel methods
    def get_channel_overview(unique_id)
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "overview",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            uniqueid: unique_id,
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def get_all_channels
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "list",
            api_key: ENV["IMPACT_MONITOR_KEY"],
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def add_monitored_item(item, unique_id)
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "add_item",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            uniqueid: unique_id,
            item: item
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def list_channel_items(unique_id)
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "list_monitored_items",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            uniqueid: unique_id
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def add_channel(channel_name)
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers:{
          params: {
            action: "add_channel",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            name: channel_name
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def delete_channel(channel_id, unique_id)
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers:{
          params: {
            action: "delete_channel",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            channel_id: channel_id.to_i,
            uniqueid: unique_id,
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    # Item methods
    def update_item(item_id, item_string)
      url = "#{IMPACT_MONITOR_URL}/items.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "update",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            item: item_string,
            item_id: item_id
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false, message: I18n.t('API.malformed_response') }
      end
    end

    def get_overview(item_id)
      url = "#{IMPACT_MONITOR_URL}/items.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "overview",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            item_id: item_id
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false, message: I18n.t('API.malformed_response') }
      end
    end

    def get_tweets(item_id)
      url = "#{IMPACT_MONITOR_URL}/items.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "list_tweets",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            item_id: item_id
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { error: true, message: I18n.t('API.malformed_response') }
      end
    end

    def get_social_shares(item_id)
      url = "#{IMPACT_MONITOR_URL}/items.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "social_shares",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            item_id: item_id
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { error: true, message: I18n.t('API.malformed_response') }
      end
    end

    def delete_item(item_id, unique_id)
      url = "#{IMPACT_MONITOR_URL}/channels.php"
      response = RestClient::Request.execute(
        method: "get",
        url: url,
        headers: {
          params: {
            action: "delete_item",
            api_key: ENV["IMPACT_MONITOR_KEY"],
            uniqueid: unique_id,
            monitored_item_id: item_id
          }
        }
      )
      return JSON.parse(response)
    end

  end
end
