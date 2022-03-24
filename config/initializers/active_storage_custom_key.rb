# frozen_string_literal: true

# ActiveStorage does not include filename (with extension) when uploading to S3, therefore this patch
# https://stackoverflow.com/questions/64108494/patch-blob-model-in-active-storage
#
Rails.application.config.to_prepare do
  # require 'active_storage/blob'

  ActiveStorage::Blob.class_eval do
    def key
      self[:key] ||= "#{self.class.generate_unique_secure_token}/#{filename}"
    end
  end
end
