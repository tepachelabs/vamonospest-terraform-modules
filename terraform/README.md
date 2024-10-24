
# Terraform Backend Setup for S3 State and DynamoDB Locking

This Terraform configuration sets up an S3 bucket for storing the Terraform state and a DynamoDB table for state locking. These resources ensure that your Terraform state is securely stored and prevent concurrent operations from causing issues by locking the state file.

## Prerequisites

- **Terraform**: Ensure you have Terraform installed. You can download it from [Terraform Downloads](https://www.terraform.io/downloads).
- **AWS Credentials**: Configure your AWS credentials using `aws configure` or through environment variables such as `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

## Structure

```bash
.
├── backend-setup           # Directory for backend resources (S3 and DynamoDB)
│   ├── main.tf             # Main Terraform configuration for S3 and DynamoDB setup
│   └── variables.tf        # Variables for environment and region
├── README.md               # This file
```

## Terraform Resources

### 1. **S3 Bucket for State Storage**
   - Stores the Terraform state file securely.
   - Versioning is enabled to keep track of state changes.
   - Public access is blocked to ensure the security of the bucket.

### 2. **DynamoDB Table for Locking**
   - Used to lock the Terraform state file during operations, ensuring only one operation can be performed at a time.

## Variables

The configuration uses the following variables:

- `region`: AWS region where the S3 bucket and DynamoDB table will be created. Default: `us-west-2`
- `environment`: Environment tag (e.g., `prod`, `dev`). This helps in tagging the resources.

## Steps to Initialize

### 1. Clone the Repository

Clone the repository or download the files containing the Terraform configuration.

```bash
git clone https://github.com/your-repo/terraform-backend-setup.git
cd terraform-backend-setup
```

### 2. Configure Variables

Make sure you adjust the variables in `variables.tf` as needed, particularly for:

- **AWS region** (`var.region`)
- **Environment** (`var.environment`)

Alternatively, you can pass them as command-line arguments during `terraform apply`:

```bash
terraform apply -var="region=us-west-2" -var="environment=prod"
```

### 3. Initialize Terraform

Initialize the Terraform project by running:

```bash
terraform init
```

This will download the necessary providers and modules for the configuration.

### 4. Apply the Configuration

Run the following command to create the S3 bucket and DynamoDB table:

```bash
terraform apply
```

Terraform will prompt for confirmation before applying the changes. Review the plan and type `yes` to proceed.

### 5. Configure Backend in Your Terraform Project

Once the S3 bucket and DynamoDB table have been created, you can update the backend configuration in your main Terraform project to use these resources for state storage and locking. Add the following block to your main Terraform project:

```hcl
terraform {
  backend "s3" {
    bucket         = "vamonospest-state-bucket"
    key            = "path/to/your/statefile.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "vamonospest-terraform-lock-table"
  }
}
```

### 6. Re-Initialize Your Main Project

Now, navigate to your main Terraform project directory and re-initialize it to use the new S3 backend:

```bash
terraform init
```

Terraform will detect the backend configuration and ask if you want to migrate the existing local state to the S3 backend.

### 7. Verify State Locking

Once the state is migrated, try running `terraform apply` in parallel from different terminals or machines. The DynamoDB table will lock the state, ensuring only one operation can proceed at a time.

## Cleanup

To destroy the S3 bucket and DynamoDB table, run:

```bash
terraform destroy
```

Note: Ensure no critical state files are stored in the S3 bucket before destruction.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
