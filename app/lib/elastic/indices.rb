class Elastic::Indices < Elastic::Base
  def all
    @client.cat
      .indices(format: :json)
      .map {|i| i["index"]}
      .reject {|i| i.start_with?(".") }
  end

  def create_index(name:)
    begin
      result = @client.indices.create(index: name, body: { mappings: Elastic.mapping(for_index: name) })
      result = JSON.parse(result) if result.is_a?(String)
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      raise e
    end

    result.dig("acknowledged") || false
  end

  def put_mapping(name:)
    @client.indices.put_mapping(index: name,  body: Elastic.mapping(for_index: name))
  end

  def delete(name:)
    @client.indices.delete(index: name)
  end

end

