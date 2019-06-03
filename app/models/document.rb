class Document < ApplicationRecord
  include Documents::Searchable

  SOURCES = %w[website].freeze
  enum source: SOURCES.freeze

  validates :title, :source, presence: true
  validates :title, uniqueness: { scope: %i[source] }

  has_one_attached :file_source

  def previewable?
    file_source.previewable?
  end
end
