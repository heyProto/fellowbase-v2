class TrackableMetricTwitterWorker

  include Sidekiq::Worker
  sidekiq_options backtrace: true


  def perform(item_id)
    puts "====> #{item_id}"
    asset = DigitalAsset.find_by(item_id: item_id)
    puts "========= #{asset.inspect}"
    response = ImpactMonitorApi.get_tweets(item_id)

    unless response["error"].present?
      tweets = response["tweets"] || []  # Done as Impact monitor returns success as true but gives tweets as nil.
      sentiments = tweets.group_by{|x| x["sentiment"]}
      sentiments.map{|k,v| sentiments[k] = v.count}

      #### Twitter Sentiments
      sentiments.each do |k,v|
        TrackableMetric.create_or_update(response["item_id"], asset.id, "twitter", "sentiment_" + k, v)
      end

      #### Twitter retweets
      retweet_count = tweets.pluck("retweets").inject{|sum, n| sum.to_i + n.to_i}
      retweet_count = retweet_count || 0
      TrackableMetric.create_or_update(response["item_id"], asset.id, "twitter", "retweets", retweet_count)
    else
      errors = asset.custom_errors || ""
      errors = errors == "" ? "Impact Monitor: #{response["message"]} (item: list_tweets API)" : "#{errors}\n\n Impact Monitor: #{response["message"]} (item: list_tweets API)"
      asset.update_attribute(:custom_errors, errors)
    end
  end

end
