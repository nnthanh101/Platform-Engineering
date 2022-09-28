# aws ssm put-parameter --name /database/password  --value mysqlpassword --type SecureString --region ap-southeast-1
aws ssm get-parameter --name "/database/tf-ecs/endpoint"  --region ap-southeast-1 --with-decryption
aws ssm get-parameter --name "/database/tf-ecs/name"      --region ap-southeast-1 --with-decryption
aws ssm get-parameter --name "/database/tf-ecs/password"  --region ap-southeast-1 --with-decryption
aws ssm get-parameter --name "/database/tf-ecs/user"      --region ap-southeast-1 --with-decryption