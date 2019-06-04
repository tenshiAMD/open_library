module Documents
  module Shareable
    extend ActiveSupport::Concern

    included do
      def share_now(recipient, message)
        DocumentMailer.with(document: self, recipient: recipient,
                            message: message).email_document.deliver_now
      end

      def share_later(recipient, message)
        DocumentMailer.with(document: self, recipient: recipient,
                            message: message).email_document.deliver_later
      end
    end
  end
end
