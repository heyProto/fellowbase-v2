class AirtableApi
  class << self
    def add_record(table_name, content_hash)
      table = connect_table(table_name)
      record = Airtable::Record.new(content_hash)
      table.create(record)
    end

    def get_table(table_name, id=nil)
      table = connect_table(table_name)
      records = table.all
    end
    
    private

    def create_client
      client = Airtable::Client.new(ENV['AIRTABLE_API_KEY'])
    end

    def connect_table(table_name)
      client = create_client
      table = client.table(ENV["AIRTABLE_APP_KEY"], table_name)
    end
  end
end
