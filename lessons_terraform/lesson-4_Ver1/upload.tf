resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.id
  key    = "cat.jpg"
  content_type = "jpg"
  source = "/mnt/e/devops/terraform/lesson-4/html/cat.jpg"
  etag = filemd5("/mnt/e/devops/terraform/lesson-4/html/cat.jpg")
}


resource "aws_s3_bucket_object" "object2" {
  bucket = aws_s3_bucket.b.id
  key    = "404.html"
  content_type = "html"
  source = "/mnt/e/devops/terraform/lesson-4/html/404.html"
  etag = filemd5("/mnt/e/devops/terraform/lesson-4/html/404.html")
}



resource "aws_s3_bucket_object" "object3" {
  bucket = aws_s3_bucket.b.id
  key    = "index.html"
  content_type = "html"
  source = "/mnt/e/devops/terraform/lesson-4/html/index.html"
  etag = filemd5("/mnt/e/devops/terraform/lesson-4/html/index.html")
}