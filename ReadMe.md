# Django Nginx Uwsgi Auto Configure Script

## Operating System
Ubuntu 14.04

## Usage:(2 params)
./DjangoNginxUwsgi.sh Project_Name Absoulte_Path_For_You_Django_Project

## After Installed
1. Run: killall uwsgi
2. Run: uwsgi -x /root/OLP/uwsgi.xml
3. Run: sudo /etc/init.d/nginx reload

## Change IP that you what be viewed
in file `/etc/nginx/django.conf`
modify : server_name 127.0.0.1 0.0.0.0 192.168.1.1 ...(each IP split with blank)
