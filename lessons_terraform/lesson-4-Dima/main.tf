provider "aws" {
  alias = "europe"
  region = "eu-central-1"
}

provider "aws" {
  alias = "central"
  region = "ca-central-1"
}




resource "aws_iam_role" "replication" {
  name = "iam-role-replication"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  name = "iam-role-policy-replication"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.website_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
         "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.website_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.backup_bucket.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}


resource "aws_s3_bucket" "backup_bucket" {
  provider = aws.europe
  bucket = "backup-s111333s555"

  }

resource "aws_s3_bucket_versioning" "backup_bucket_version" {
    provider = aws.europe
  bucket = aws_s3_bucket.backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "website_bucket" {
  provider = aws.central
  bucket = "s111333s555"
   acl    = "private"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "index" {
    provider = aws.central
  bucket = aws_s3_bucket.website_bucket.id
  source = "./index.html"
  key = "index.html"
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "website_bucket_version" {
    provider = aws.central
    bucket = aws_s3_bucket.website_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}


resource "aws_s3_bucket_replication_configuration" "replication" {
    provider = aws.central
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.website_bucket_version]
  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    id = "replic"
    prefix = ""
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.backup_bucket.arn
      storage_class = "STANDARD"
    }
  }
}