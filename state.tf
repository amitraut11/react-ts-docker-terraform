terraform{
    backend "s3" {
        bucket = "terraform-backend-bucket-v2"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
        
    }
}

provider "aws" {
    region = "us-east-1"
    
}