class GlobalResource < JSONAPI::Resource
  include ResourceNodeCount

  attributes :node_counts

  def self.find_by_key(_key, options={})
    context = options[:context]
    model = Global.new
    new(model, context)
  end

  def self.verify_key(key, _context = nil)
    key && String(key)
  end
end
