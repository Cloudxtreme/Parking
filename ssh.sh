#!/bin/bash

# Name of the Google Cloud project that this server will be deployed to
GCEPROJECTNAME='q42-parking'
# Used as directory, database and server name:
APPNAME='q42parking'
ZONE='europe-west1-c'

gcloud compute \
  --project $GCEPROJECTNAME ssh \
  --zone $ZONE $APPNAME
