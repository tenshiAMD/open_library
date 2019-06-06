class DocumentMailer < ApplicationMailer
  def email_document
    document = params[:document]
    @body = params[:message]
    recipient = params[:recipient]

    file_attachment = document.file_source
    if file_attachment.present?
      filename = file_attachment.attached? ? file_attachment.filename.to_s : ""

      blob_service = ActiveStorage::Blob.service
      if blob_service.respond_to?(:path_for)
        file = File.read(blob_service.send(:path_for, file_attachment.key))
      elsif [blob_service,
             file_attachment].all? { |a| a.respond_to?(:download) }
        file = file_attachment.download
      end

      attachments.inline[filename] = file
    end

    recipient = Mail::Address.new(recipient)

    mail(to: recipient.format, subject: document.title)
  end
end
