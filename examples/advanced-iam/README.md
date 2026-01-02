# Advanced IAM Example

This example demonstrates advanced IAM configuration including inline policies, permission boundaries, and DynamoDB access.

## Features Demonstrated

- **Inline Policy**: Grant specific DynamoDB permissions
- **Permission Boundary**: Limit maximum possible permissions
- **Least Privilege**: Only grant necessary permissions

## Permission Boundary

The permission boundary prevents the Lambda role from ever having permissions beyond what's defined, even if someone attaches additional policies:

```hcl
permission_boundary_arn = aws_iam_policy.boundary.arn
```

This is a security best practice for production environments.

## Inline Policy

Use inline policies for application-specific permissions:

```hcl
inline_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Effect   = "Allow"
      Action   = ["dynamodb:GetItem", "dynamodb:PutItem"]
      Resource = aws_dynamodb_table.orders.arn
    }
  ]
})
```

## Additional Policy ARNs

For AWS managed policies:

```hcl
additional_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
]
```

## Deployment

```bash
tofu init
tofu apply
```

## Testing

After deployment, you can test the Lambda:

```bash
aws lambda invoke \
  --function-name example-orders-api \
  --payload '{"order_id": "123"}' \
  response.json
```
