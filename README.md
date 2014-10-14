[![Code Climate](https://codeclimate.com/github/tscolari/s3push.png)](https://codeclimate.com/github/tscolari/s3push)

S3push
====

Single "file" backup tool with versions to S3.

The objective is to backup individual files with versions on S3,
for example keeping database backups.

```
Usage: s3push OPTIONS
    -k, --aws-key-id KEY_ID          AWS key id
    -a, --aws-access-key ACCESS_KEY  AWS access key
    -b, --s3-bucket BUCKET_NAME      S3 bucket name
    -v, --verbose                    Verbose
    -f, --file_name REMOTE_FILENAME  Target folder in s3, e.g. 'production'
    --keep [10]                      Number of versions to keep
```

Example:

```
pg_dump ... | gzip | s3push -k $AWS_KEY -a $AWS_SECRET -b my_bucket -f backups/postgres.gz
```

this will create inside the bucket:

```
  /backups/postgres.gz/TIMESTAMP
```

the `--keep` option controls how many versions do you want to keep, by default it keeps 10.

Theoretically it can backup anything you can pipe through the command line.

Other examples:

* `cat big_backup.gz | s3push -k $AWS_KEY -a $AWS_SECRET -b my_bucket -f backups/postgres.gz`
* `tar cz | s3push -k $AWS_KEY -a $AWS_SECRET -b my_bucket -f backups/postgres.gz`

