module S3push
  class CommandLine
    require 'optparse'
    require 'logger'

    def run(args, file)
      logger = Logger.new($stdout)
      logger.level = Logger::WARN

      options = fetch_options(args, logger)
      Backup.new(options.delete(:key_id), options.delete(:access_key), logger).
        run(options.delete(:bucket), options.delete(:file_name), file.read, options.delete(:keep))
    end

    private

    def fetch_options(args, logger)
      Hash.new.tap do |options|
        OptionParser.new do |opts|
          opts.banner = 'Usage: s3push OPTIONS'

          opts.on('-k', '--aws-key-id KEY_ID', 'AWS key id') do |key_id|
            options[:key_id] = key_id
          end

          opts.on('-a', '--aws-access-key ACCESS_KEY', 'AWS access key') do |access_key|
            options[:access_key] = access_key
          end

          opts.on('-b', '--s3-bucket BUCKET_NAME', 'S3 bucket name') do |bucket_name|
            options[:bucket] = bucket_name
          end

          opts.on('-v', '--verbose', 'Verbose') do
            logger.level = Logger::INFO
          end

          opts.on('--keep [10]', 'Backups to keep') do |keep|
            options[:keep] = keep
          end

          opts.on('-f', '--file_name REMOTE_FILE_NAME', 'Backups filename in S3') do |file_name|
            options[:file_name] = file_name
          end

        end.parse!(args)
      end
    end

  end
end
