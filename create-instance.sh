#!/bin/bash

# Change this to your GCS bucket name:
BUCKET='q42-parking-deploys'
# Name of the Google Cloud project that this server will be deployed to
GCEPROJECTNAME='q42-parking'
# Used as directory, database and server name:
APPNAME='q42parking'
# The first time you create an instance, it's assigned an ipaddress.
# In cloud dashboard, make the ip static and fill it here.
EXTERNALIP='146.148.125.51'
ZONE='europe-west1-c'

echo Building a meteor package...
rm ../$APPNAME.tar.gz
meteor build .. --architecture os.linux.x86_64
mv ../parking.q42.nl.tar.gz ../$APPNAME.tar.gz

echo Upload the meteor package...
gsutil cp ../$APPNAME.tar.gz gs://$BUCKET/versions/default.tar.gz
gsutil cp startup-gce.sh gs://$BUCKET

echo Deleting old instance named $APPNAME
gcloud compute instances delete $APPNAME \
  --project $GCEPROJECTNAME \
  --zone $ZONE \
  --quiet

echo Creating instance with startup script...
gcloud compute instances create $APPNAME \
  --project $GCEPROJECTNAME \
  --zone $ZONE \
  --machine-type "g1-small" \
  --tags "http-server" \
  --scopes storage-ro \
  --address $EXTERNALIP \
  --metadata startup-script-url=gs://$BUCKET/startup-gce.sh \
  --disk "name="$APPNAME"-data" "mode=rw" "boot=no"
