require "spec_helper"

RSpec.describe Document, type: :model do
  describe "db" do
    context "columns" do
      it { should have_db_column(:id).of_type(:integer).with_options(null: false) }
      it { should have_db_column(:title).of_type(:string).with_options(null: false) }
      it { should have_db_column(:source).of_type(:integer).with_options(null: false, default: Document::SOURCES[0]) }
      it { should have_db_column(:url).of_type(:string).with_options(null: true) }
      it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
      it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    end

    context "indexes" do
      it { should have_db_index(%i[source title]).unique(true) }
    end
  end

  describe "validations" do
    subject { build(:document) }

    context "presence" do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:source) }
    end

    context "uniqueness" do
      it { should validate_uniqueness_of(:title).scoped_to(:source) }
    end

    it { is_expected.to be_valid }
  end

  describe "previewable?" do
    let(:document) { create(:document) }

    subject { document.previewable? }

    context "when no attachment available" do
      it { is_expected.to be_falsey }
    end

    context "when attachment available" do
      it do
        filepath = Rails.root.join("spec", "fixtures", "sample.pdf")
        document.file_source.attach(io: File.open(filepath), filename: "sample.pdf")

        is_expected.to be_truthy
      end
    end
  end

  describe "share_later?" do
    let(:document) { create(:document) }
    let(:recipient) { "amdomaoan@cdasia.com" }
    let(:message) { "testing" }

    it "triggers queue for sending email" do
      expect { document.share_later(recipient, message) }.to have_enqueued_job.on_queue("mailers")
    end
  end

  describe "share_now?" do
    let(:document) { create(:document) }
    let(:recipient) { "amdomaoan@cdasia.com" }
    let(:message) { "testing" }

    it "sends email directly" do
      document.share_now(recipient, message)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq document.title
      expect(mail.to).to eq Array(recipient)
    end
  end
end
