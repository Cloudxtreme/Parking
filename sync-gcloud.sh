# running on production server at /opt/q42/sync-gcloud.sh
# run by crontab: sudo crontab -u karsveling -l
# # m h  dom mon dow   command
# */1 * * * * /opt/q42/sync-gcloud.sh

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
HOME=/home/karsveling
sudo gsutil rsync -r gs://q42websites /data/websites >> /var/log/sync-gcloud.log

# already ran sudo git clone https://github.com/Q42/Parking.git, now just update

cd /data/Parking
sudo git fetch
LOCAL=$(git rev-parse @{0})
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @{0} @{u})

if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
    sudo git pull
    sudo /etc/init.d/nginx reload
elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
else
    echo "Diverged"
fi
