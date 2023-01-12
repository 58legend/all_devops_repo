provider "aws" {
}
resource "aws_s3_bucket" "m5" {
 bucket = "bc55158"
 acl = "private"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
resource "aws_s3_bucket_versioning" "versioning_example"{
    bucket = aws_s3_bucket.m5.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_object" "index" {
    bucket = aws_s3_bucket.m5.id
    acl    = "public-read"
    key    = "index.html"
    content_type = "html"
    source = "/mnt/e/devops/terraform/lesson-4/html/index.html"
}
resource "aws_s3_bucket_object" "error" {
    bucket = aws_s3_bucket.m5.id
    key = "error.html"
    source = "/mnt/e/devops/terraform/lesson-4/html/404.html"
    acl = "public-read"
}
resource "aws_s3_bucket_object" "re" {
    bucket = aws_s3_bucket.m5.id
    key = "cat.jpg"
   source = "/mnt/e/devops/terraform/lesson-4/html/cat.jpg"
    acl = "public-read"
} 

resource "aws_iam_role" "replication" {
  name = "tf-iam-role-replication-12345"

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
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.m5.arn}"
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
        "${aws_s3_bucket.m5.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.m6.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

######################
provider "aws" {
  region = "eu-central-1"
  alias = "Frankfurt" 
}

resource "aws_s3_bucket" "m6" {
bucket = "bc551.backup58"
provider = aws.Frankfurt  
}

resource "aws_s3_bucket_acl" "mm" {
  provider = aws.Frankfurt
  bucket = aws_s3_bucket.m6.id
  acl = "private"
  
}

resource "aws_s3_bucket_versioning" "versioning_example2"{
    bucket = aws_s3_bucket.m6.id
    provider = aws.Frankfurt
    versioning_configuration {
      status = "Enabled"
    }
}

#-----------





resource "aws_s3_bucket_replication_configuration" "replication" {
  # Must have bucket versioning enabled first
 depends_on = [aws_s3_bucket_versioning.versioning_example]
  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.m5.id

  rule {
   # delete_marker_replication {
      # status = "Disabled"
    #}
    id = "foobarmy"
    prefix = ""
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.m6.arn
      storage_class = "STANDARD"
    }
  }
}