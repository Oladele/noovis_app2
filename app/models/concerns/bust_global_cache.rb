require 'active_support/concern'

module BustGlobalCache
  extend ActiveSupport::Concern

  included do
    after_create :bust_global_cache
    after_destroy :bust_global_cache
  end

  private
    def bust_global_cache
      Rails.cache.delete(GlobalResource::CACHE_KEY)
    end
end
