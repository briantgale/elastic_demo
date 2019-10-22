class Elastic::Data < Elastic::Base

  def index_data(index:, id:, body:)
    raise "body must be a hash object" unless body.is_a?(Hash)

    begin
      @client.index(index: index, id: id, type: "_doc", body: body)
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      reason = parse_response_message(e.message).dig("error", "reason")

      raise "Received error when indexing document - #{reason}" if reason
      raise "Received error when indexing document"
    end
  end

  def find(index:, id:)
    begin
      @client.get(index: index, type: "_doc", id: id)
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      raise "Document not found"
    end
  end

  def search(index:, body:, scroll: nil)
    return @client.search(index: index, body: body, scroll: scroll) if scroll
    @client.search(index: index, body: body)
  end

  def count(index:, body:)
    @client.count(index: index, body: body)
  end

  def scroll(body:)
    @client.scroll(body: body)
  end

end

