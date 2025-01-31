# Hosting a Static Website Using AWS S3 with Terraform

This repository contains Terraform configurations to host a static website on an **Amazon S3 bucket**. The setup includes bucket creation, public access permissions, website configuration, and deployment of an `index.html` file.

## Features

- **S3 Bucket Creation**: Creates an S3 bucket named `itsroshanr`.
- **Public Access Configuration**: Allows public read access to website content.
- **Bucket Policy**: Grants public access to `index.html`.
- **Website Hosting Configuration**: Configures S3 for static website hosting with an `index.html` file.
- **Terraform-Based Deployment**: Automates infrastructure provisioning.

## Prerequisites

Ensure you have the following installed:

- **Terraform**
- **AWS CLI** (configured with appropriate IAM permissions)
- **An AWS Account**

## Terraform Setup & Deployment

### 1. Initialize Terraform

```sh
terraform init
```

### 2. Preview the Changes

```sh
terraform plan
```

### 3. Apply the Configuration

```sh
terraform apply -auto-approve
```

### 4. Retrieve the Website URL

Once deployed, you can access the website via:

```sh
aws s3 website s3://itsroshanr/
```

## Terraform Resources Explained

### **1. S3 Bucket Creation**

```hcl
resource "aws_s3_bucket" "itsroshanr" {
  bucket = "itsroshanr"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
```

Creates an S3 bucket with the name `itsroshanr`.

### **2. Public Access Permissions**

```hcl
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.itsroshanr.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

Allows public access by disabling ACL and policy restrictions.

### **3. S3 Bucket Policy for Public Access**

```hcl
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.itsroshanr.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}
```

Defines an IAM policy document allowing public read access.

### **4. Uploading Website Content**

```hcl
resource "aws_s3_object" "object" {
  bucket = "itsroshanr"
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
  etag = filemd5("index.html")
}
```

Uploads `index.html` to the S3 bucket.

### **5. Enabling Static Website Hosting**

```hcl
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.itsroshanr.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
```

Configures the S3 bucket for static website hosting.

## Destroying the Resources

To remove the S3 bucket and associated resources:

```sh
terraform destroy -auto-approve
```

## Notes

- The website URL format will be: `http://itsroshanr.s3-website-us-east-1.amazonaws.com`.
- Ensure the `index.html` file exists in your local directory before applying Terraform.
