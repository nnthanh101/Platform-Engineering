#!/bin/bash

yum update -y

yum install -y httpd

systemctl start httpd
systemctl enable httpd

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www

chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;


INSTANCE_INFO=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document)

INSTANCE_ID=$(printf "$INSTANCE_INFO" |  grep instanceId | awk '{print $3}' | sed s/','//g | sed s/'"'//g)

INSTANCE_AZ=$(printf "$INSTANCE_INFO" |  grep availabilityZone | awk '{print $3}' | sed s/','//g | sed s/'"'//g)

INSTANCE_TYPE=$(printf "$INSTANCE_INFO" |  grep instanceType | awk '{print $3}' | sed s/','//g | sed s/'"'//g)

INSTANCE_REGION=$(printf "$INSTANCE_INFO" |  grep region | awk '{print $3}' | sed s/','//g | sed s/'"'//g)


### index.html landing page

cat <<EOF >> /var/www/html/index.html
<!DOCTYPE html>
<html>

<head>
  <title>AWS Instance</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body {
      background-color: orange;
      text-align: center;
      color: white;
    }

    .centered {
      position: fixed;
      top: 50%;
      left: 50%;
      /* bring your own prefixes */
      transform: translate(-50%, -50%);
    }
  </style>
</head>

<body>
  <center><h1>MY AWS instance</h1></center>
  <div class=centered>

    <h2>Instance ID: <code> ${INSTANCE_ID} </code> </h2>

    <h2>Instance Type: <code> ${INSTANCE_TYPE} </code> </h2>

    <h2>Instance Region: <code> ${INSTANCE_REGION} </code> </h2>

    <h2>Availability Zone: <code> ${INSTANCE_AZ} </code> </h2>
  </div>
</body>

</html>
EOF