class Elastic::Base
  attr_reader :client

  # Set up the elasticsearch client and log levels
  def initialize
    @client = Elasticsearch::Client.new log: true, host: (ENV["ELASTICSEARCH_HOST"] || "http://localhost:9200")
    @client.transport.logger.level = Logger::DEBUG if Rails.env.development?
    @client.transport.logger.level = Logger::ERROR if Rails.env.test?
    @client.transport.logger.level = Logger::INFO unless %w[development test].include?(Rails.env)
  end

  private

  # Parse out the JSON part of a returned error message
  def parse_response_message(message)
    JSON.parse(message.gsub(/\[\d{3}\]\s/, ""))
  end

end

