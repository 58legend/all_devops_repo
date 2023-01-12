provider "aws" {
region = "eu-central-1"
}

provider "aws" {
  alias  = "west"
  region = "eu-west-1"
}
resource "aws_iam_role" "replication" {
  name = "tf-iam-role-replication-1234511158"

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
  name = "tf-iam-role-policy-replication-12345"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.source.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
         "s3:GetObjectVersionTagging",
         "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.source.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.destination.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket" "destination" {
  provider = aws.west
  acl    = "public-read"
  bucket = "lesson-4-replication2"
}

resource "aws_s3_bucket_versioning" "destination" {
  provider = aws.west
  bucket = aws_s3_bucket.destination.id
  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket" "source" {
  bucket   = "lesson-4-original2"
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

#resource "aws_s3_bucket_acl" "source_bucket_acl" {
#  bucket = aws_s3_bucket.source.id
#}


resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  #provider = aws.west
  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source.id

  rule {
    id = "foobar"

    filter {
      prefix = ""
    }


delete_marker_replication {
      status = "Disabled"
    }
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}



output "endpoint" {
  value = aws_s3_bucket.source.website_endpoint
}
