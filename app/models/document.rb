class Document < ApplicationRecord
  include Documents::Searchable
  include Documents::Shareable

  SOURCES = %w[website].freeze
  enum source: SOURCES.freeze

  validates :title, :source, presence: true
  validates :title, uniqueness: { scope: %i[source] }

  has_one_attached :file_source

  def previewable?
    return false if file_source.blank?

    file_source.previewable?
  end
end
