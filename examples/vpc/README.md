# VPC Example

This example demonstrates deploying a Lambda function inside a VPC for network isolation.

## Use Cases

- Accessing private RDS databases
- Connecting to ElastiCache clusters
- Accessing resources in private subnets
- Network-level security isolation

## Prerequisites

- A VPC with private subnets
- NAT Gateway (if Lambda needs internet access)
- Or VPC endpoints for AWS services

## Important Notes

1. **Cold Start Impact**: VPC Lambdas may have slightly longer cold starts due to ENI attachment
2. **Internet Access**: Lambda in VPC has no internet access unless:
   - Deployed in private subnet with NAT Gateway
   - Uses VPC endpoints for AWS services
3. **IAM**: The module automatically attaches `AWSLambdaVPCAccessExecutionRole`

## Security Group Rules

The example creates an egress-only security group. Modify based on your needs:

```hcl
# Example: Allow access to RDS on port 5432
ingress {
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  self            = true
}

egress {
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
}
```

## Deployment

```bash
tofu init
tofu apply
```
