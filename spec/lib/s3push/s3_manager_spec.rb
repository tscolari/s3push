require 'spec_helper'

module S3push
  describe S3Mananger do
    let(:key_id) { SecureRandom.uuid }
    let(:access_key) { SecureRandom.hex }
    let(:bucket_name) { "my_backup_bucket" }
    let(:logger) { Logger.new('/dev/null') }
    let(:file_name) { "backup" }

    subject { S3Mananger.new(key_id, access_key, logger) }

    describe "#upload" do
      let(:file) { "Some text" }
      before { allow(subject).to receive(:open).and_return("") }

      it "should upload the file to s3" do
        expect(AWS::S3::S3Object).to receive(:store)
          .with(Regexp.new(file_name), file, bucket_name)
        subject.upload(bucket_name, file_name, file)
      end
    end

    describe "#clean_up" do
      let(:bucket) do
        [OpenStruct.new(key: 'backup/1'), OpenStruct.new(key: 'backup/2'), OpenStruct.new(key: 'backup/3')]
      end

      before do
        allow(AWS::S3::Bucket).to receive(:find).and_return(bucket)
      end

      it "should delete the oldest superfluous files" do
        expect(AWS::S3::S3Object).to receive(:delete).with('backup/1', bucket_name)
        expect(AWS::S3::S3Object).to receive(:delete).with('backup/2', bucket_name)
        subject.cleanup(bucket_name, file_name, 1)
      end
    end

    describe "#backup_list" do
      let(:bucket) do
        [OpenStruct.new(key: 'backup/1'), OpenStruct.new(key: 'backup/2')]
      end

      before do
        allow(AWS::S3::Bucket).to receive(:find).and_return(bucket)
      end

      it "should list all backuped file versions" do
        expect(subject.backups_list(bucket_name, file_name))
          .to eq(['backup/1', 'backup/2'])
      end
    end

  end
end
