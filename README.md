# OCR File Processing with AWS 🌐📸

This project provides a serverless solution for OCR (Optical Character Recognition) file processing using AWS services. It leverages the power of AWS S3, Lambda, API Gateway, Textract, and DynamoDB to perform OCR operations on images uploaded to an S3 bucket and store the results in DynamoDB.

## 🚀 Project Overview

- **S3 Bucket**: Stores images for processing 📂.
- **Lambda Function**: Processes images with AWS Textract 🔍 and stores the results in DynamoDB.
- **DynamoDB**: Stores OCR results, indexed by image name 📝.
- **API Gateway**: Provides a POST endpoint for image uploads 💻.
- **IAM Roles**: Ensures proper permissions for all services 🔑.

## 🗂 Project Structure

- `main.tf`: Terraform configuration for provisioning AWS resources 🛠.
- `lambda_function.py`: Python code for the Lambda function 🤖.
- `lambda_function.zip`: Zipped Lambda deployment package 📦.

## 🌍 AWS Services Used

- **Amazon S3**: For storing images and serving them 📥.
- **AWS Lambda**: Serverless compute for image processing 🖥.
- **Amazon Textract**: Extracts text from images 🔠.
- **Amazon DynamoDB**: Stores text data 🗄.
- **Amazon API Gateway**: Handles API requests 🌐.
- **IAM Roles**: Ensures secure permissions 🔐.

## 📝 Prerequisites

Before deploying, ensure you have:

- AWS account with permissions to create S3, Lambda, DynamoDB, API Gateway, and IAM resources 🌐.
- Terraform installed 🌱.
- A ZIP file of the Lambda function (i.e., `lambda_function.zip`) 📦.

## ⚡ Setup Instructions

1. **Clone this repository**:

   ```bash
   git clone https://github.com/idan5353/TextReco.git
  
