# Django Nginx Uwsgi Auto Configure Script

## Operating System
Linux Universal

## Usage:(3 params)
./DjangoNginxUwsgi.sh Project_Name Absoulte_Path_For_You_Django_Project NGINX_PATH

## After Installed
1. Run: killall uwsgi
2. Run: uwsgi -x /path/to/uwsgi.xml
3. Run: sudo /etc/init.d/nginx reload

## Change IP that you what be viewed
in file `/path/to/nginx/django.conf`
modify : server_name 127.0.0.1 0.0.0.0 192.168.1.1 ...(each IP split with blank)

# Change User
in file `/path/to/nginx/nginx.cof`
"user www-data;"  ---Change to--> "user root admin;"
(Take notice: in here root or admin is your nginx user)

