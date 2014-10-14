module S3push
  class Backup

    def initialize(key_id, access_key, logger = Logger.new)
      @logger = logger
      @s3_manager = S3Mananger.new(key_id, access_key, @logger)
    end

    def run(bucket_name, file_name, file_content, keep)
      backup(bucket_name, file_name, file_content)
      cleanup(bucket_name, file_name, keep || 10)
    end

    private

    def backup(bucket, backup_file_name, content)
      @s3_manager.upload(bucket, backup_file_name, content)
    end

    def cleanup(bucket_name, file_name, keep)
      @s3_manager.cleanup(bucket_name, file_name, keep)
    end

  end
end
