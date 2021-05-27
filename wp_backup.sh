#!/bin/bash
 

export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%Y-%b-%d"`
 
################################################################
################## Update below values  ########################
 
DB_BACKUP_PATH='/backups/db/'
FILES_BACKUP_PATH='/backups/files/'
FILE_PATH='/var/www/wordpress'
FILENAME='Wordpress'
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='DB_user'
MYSQL_PASSWORD='7y3rhcj8U6qV3A79'
DATABASE_NAME='DB_name'
BACKUP_RETAIN_DAYS=15   ## Number of days to keep local backup copy
 
#################################################################
 
mkdir -p ${DB_BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"
 
 
mysqldump -h ${MYSQL_HOST} \
   -P ${MYSQL_PORT} \
   -u ${MYSQL_USER} \
   -p${MYSQL_PASSWORD} \
   ${DATABASE_NAME} | gzip > ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz
 
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi
 
 
##### Remove backups older than {BACKUP_RETAIN_DAYS} days  #####
 
DBDELDATE=`date +"%Y-%b-%d" --date="${BACKUP_RETAIN_DAYS} days ago"`
 
if [ ! -z ${DB_BACKUP_PATH} ]; then
      cd ${DB_BACKUP_PATH}
      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
            rm -rf ${DBDELDATE}
      fi
fi

######################
mkdir -p ${FILES_BACKUP_PATH}/${TODAY}
echo "Backup started for Files - ${FILE_PATH}"
tar -cpzf ${FILES_BACKUP_PATH}/${TODAY}/${FILENAME}-${TODAY}.tar.gz $FILE_PATH

if [ $? -eq 0 ]; then
  echo "FILES backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi
 
 
##### Remove FILES older than {BACKUP_RETAIN_DAYS} days  #####
 
FILEDELDATE=`date +"%Y-%b-%d" --date="${BACKUP_RETAIN_DAYS} days ago"`
 
if [ ! -z ${FILES_BACKUP_PATH} ]; then
      cd ${FILES_BACKUP_PATH}
      if [ ! -z ${FILEDELDATE} ] && [ -d ${FILEDELDATE} ]; then
            rm -rf ${FILEDELDATE}
      fi
fi

