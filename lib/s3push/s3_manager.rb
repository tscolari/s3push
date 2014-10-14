require 'aws/s3'

module S3push
  class S3Mananger

    def initialize(key_id, access_key, logger = Logger.new)
      connect!(key_id, access_key)
      @logger = logger
    end

    def upload(bucket, file_name, file_content)
      target_name = create_target_name(file_name)
      @logger.info("Uploading file: #{target_name}...")
      AWS::S3::S3Object.store(target_name, file_content, bucket)
    end

    def backups_list(bucket_name, file_name)
      bucket = AWS::S3::Bucket.find(bucket_name)
      backups = bucket.map(&:key).sort
      backups.select { |file| file.include?(file_name) }
    end

    def cleanup(bucket_name, file_name, backups_to_keep = 10)
      expired_backups = backups_to_delete(bucket_name, file_name, backups_to_keep)
      expired_backups.each do |backup|
        @logger.info("Deleting old backup: #{backup}...")
        AWS::S3::S3Object.delete backup, bucket_name
      end
    end

    private

    def backups_to_delete(bucket, file_name, backups_to_keep)
      backups = backups_list(bucket, file_name)
      backups - backups.last(backups_to_keep.to_i)
    end

    def create_target_name(file_name)
      "#{file_name}/#{timestamp}"
    end

    def timestamp
      @timestamp ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def connect!(key_id, access_key)
      AWS::S3::Base.establish_connection!(
        :access_key_id     => key_id,
        :secret_access_key => access_key
      )
    end

  end
end
