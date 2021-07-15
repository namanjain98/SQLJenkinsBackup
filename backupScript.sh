#!/bin/bash
DB_BACKUP_PATH='backup/dbbackup'
MYSQL_HOST=$(aws ssm get-parameter  --name "/jenkins/first/db-url" --with-decryption --output text --query Parameter.Value --region "us-east-1")
MYSQL_PORT='3306'
MYSQL_USER=$(aws ssm get-parameter  --name "/jenkins/first/db-user" --with-decryption --output text --query Parameter.Value --region "us-east-1")
MYSQL_PASSWORD=$(aws ssm get-parameter  --name "/jenkins/first/db-password" --with-decryption --output text --query Parameter.Value --region "us-east-1")
DATABASE_NAME='naman'
 
mkdir -p ${DB_BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"
    
mysqldump -h ${MYSQL_HOST} \
   -P ${MYSQL_PORT} \
   -u ${MYSQL_USER} \
   -p${MYSQL_PASSWORD} \
   ${DATABASE_NAME} > ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql
 
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi

aws s3 cp /var/lib/jenkins/workspace/naman/backup/dbbackup s3://namanjnjdnsaj/ --recursive
