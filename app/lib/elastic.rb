module Elastic

  OBJECT_MAPPINGS = {}

  def self.mapping(for_index:)
    pieces = for_index.match(/(company_\d+_)(.*)/).to_a
    object_name = pieces.last&.to_sym
    OBJECT_MAPPINGS[object_name] || {}
  end
end
