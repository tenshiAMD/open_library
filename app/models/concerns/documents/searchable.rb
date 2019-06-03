module Documents
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks

      # https://github.com/elastic/elasticsearch-rails/issues/96
      def self.search_for(*args, &block)
        __elasticsearch__.search(*args, &block)
      end
    end
  end
end
