#!/bin/bash

aws s3api put-bucket-versioning --bucket ${TF_STATE_S3_BUCKET} --versioning-configuration Status=Suspended

echo "Removing all versions from ${TF_STATE_S3_BUCKET}"
versions=`aws s3api list-object-versions --bucket ${TF_STATE_S3_BUCKET} |jq '.Versions'`
markers=`aws s3api list-object-versions --bucket ${TF_STATE_S3_BUCKET} |jq '.DeleteMarkers'`
let count=`echo $versions |jq 'length'`-1
if [ $count -gt -1 ]; then
        echo "removing files"
        for i in $(seq 0 $count); do
                key=`echo $versions | jq .[$i].Key |sed -e 's/\"//g'`
                versionId=`echo $versions | jq .[$i].VersionId |sed -e 's/\"//g'`
                cmd="aws s3api delete-object --bucket ${TF_STATE_S3_BUCKET} --key $key --version-id $versionId"
                $cmd
        done
fi

let count=`echo $markers |jq 'length'`-1
if [ $count -gt -1 ]; then
        echo "removing delete markers"

        for i in $(seq 0 $count); do
                key=`echo $markers | jq .[$i].Key |sed -e 's/\"//g'`
                versionId=`echo $markers | jq .[$i].VersionId |sed -e 's/\"//g'`
                cmd="aws s3api delete-object --bucket ${TF_STATE_S3_BUCKET} --key $key --version-id $versionId"
                $cmd
        done
fi

sleep 15
aws s3 rm s3://${TF_STATE_S3_BUCKET}/ --recursive || true
aws s3 rb s3://${TF_STATE_S3_BUCKET} || true
