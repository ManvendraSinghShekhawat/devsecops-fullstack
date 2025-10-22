control 's3-backup-bucket' do
  impact 1.0
  title 'S3 backup bucket has versioning and encryption'
  describe aws_s3_bucket(bucket_name: attribute('s3_bucket', default: '<S3_BUCKET_NAME>')) do
    it { should exist }
    it { should have_versioning_enabled }
    it { should have_default_encryption_enabled }
  end
end

