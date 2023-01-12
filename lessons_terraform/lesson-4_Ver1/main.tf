/*

- створити бакет веб, де буде якась картинка
- створити ще один бакет і налаштувати щоб він був бекапом першого бакета
- в перший бакет закинути вручну чи через AWS CLI ще пару файлів і картинку з таким же імям але іншу

*/


provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "b" {
  bucket = "58legend-lesson4-s3-bucket1"
  acl    = "public-read"
  
    website {
    index_document = "index.html"
    error_document = "index.html"
  }
}
  
resource "aws_s3_bucket_policy" "b" {  
  bucket = aws_s3_bucket.b.id   
policy = <<POLICY
{    
    "Version": "2012-10-17",    
    "Statement": [        
      {            
          "Sid": "PublicReadGetObject",            
          "Effect": "Allow",            
          "Principal": "*",            
          "Action": [                
             "s3:GetObject"            
          ],            
          "Resource": [
             "arn:aws:s3:::${aws_s3_bucket.b.id}/*"            
          ]        
      }    
    ]
}
POLICY
}
resource "aws_s3_bucket_versioning" "versioning_example" {
    bucket = aws_s3_bucket.b.id
    versioning_configuration {
      status = "Enabled"
    }
}
/*
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.id
  key    = "cat.png"
  type = "jpg"
  source = "/mnt/e/cat.jpg"

  etag = filemd5("/mnt/e/cat.jpg")
}
*/
 /* policy = <<POLICY
{    
    "Version": "2012-10-17",    
    "Statement": [        
      {            
          "Sid": "PublicReadGetObject",            
          "Effect": "Allow",            
          "Principal": "*",            
          "Action": [                
             "s3:GetObject"            
          ],            
          "Resource": [
             "arn:aws:s3:::${aws_s3_bucket.b.id}/*"            
          ]        
      }    
    ]
}
POLICY
}

resource "aws_s3_bucket_versioning" "versioning_example" {
    bucket = aws_s3_bucket.b.id
    versioning_configuration {
      status = "Enabled"
    }
}*/