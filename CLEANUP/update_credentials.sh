#!/bin/bash

echo -e "export AWS_ACCESS_KEY_ID=..."
echo -e "export AWS_SECRET_ACCESS_KEY=..."

echo -e "[default]\naws_access_key_id = $AWS_ACCESS_KEY_ID\naws_secret_access_key = $AWS_SECRET_ACCESS_KEY\naws_session_token = $AWS_SESSION_TOKEN\n" > ~/.aws/credentials
