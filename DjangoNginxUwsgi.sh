#!/bin/bash

# 1、确定项目路径
if [ "$#" != "2" ]; then
    echo "    Usage: "
    echo "        $0 Project_Name Absoulte_Path_For_You_Django_Project."
    exit
fi

PROJECT_NAME=$1
PROJECT_PATH=$2
LOG=$(pwd)"/DNU.logs"

if [ -f "$LOG" ]; then
    rm -rf $LOG
fi

function errorLog() {
    if [ "$1" != "0" ]; then
        echo "ERROR: Failed to install $2" >> $LOG
    else
        echo "Succeed in installing $2" >> $LOG  
    fi
}

# 2、安装软件
which nginx >> /dev/null
if [ "$?" != "0" ]; then
    sudo apt-get install -y nginx
    errorLog $? nginx
else
    echo "已经安装 nginx" >> $LOG  
fi

which uwsgi >> /dev/null
if [ "$?" != "0" ]; then
    pip install uwsgi
    if [ "$?" != "0" ]; then
        sudo apt-get install -y uwsgi
        errorLog $? uwsgi
    fi
else
    echo "已经安装 uwsgi" >> $LOG  
fi

pip install flup
if [ "$?" != "0" ]; then
    sudo apt-get install python-flup
    errorLog $? python-flup
fi


# 3 配置文件django_wsgi.py
cp django_wsgi.py $PROJECT_PATH
cd $PROJECT_PATH
sed -i "s%PROJECT_NAME%$PROJECT_NAME%g" django_wsgi.py
cd -

# 4 配置文件uwsgi
cp uwsgi.xml $PROJECT_PATH
cd $PROJECT_PATH
sed -i "s%PROJECT_PATH%$PROJECT_PATH%g" uwsgi.xml
cd -

# 5 配置文件django.conf
nginxLogDir=$PROJECT_PATH"/logs"
if [ ! -d "$nginxLogDir" ]; then
    mkdir $nginxLogDir
fi
cp django.conf $PROJECT_PATH
cd $PROJECT_PATH
sed -i "s%PROJECT_PATH%$PROJECT_PATH%g" django.conf
sudo mv django.conf /etc/nginx
cd -

# 6 配置文件nginx.conf
sudo cp nginx.conf /etc/nginx

# 7 启动
ps -e | grep -i uwsgi
if [ "$?" != "0" ]; then
    killall uwsgi
fi
# sudo /etc/init.d/nginx reload
# uwsgi -x $PROJECT_PATH"/uwsgi.xml"

echo "Now, you need to reload nginx:"
echo "    Run: sudo /etc/init.d/nginx reload"

echo "Then: start config uwsgi: "
echo "    Run: uwsgi $PROJECT_PATH/uwsgi.xml"

echo "If you want to stop uwsgi: "
echo "  You can go through the process uwsgi first"
echo "    Run: ps -e | grep uwsgi"
echo "  If you wantt to stop:"
echo "    Run: killall uwsgi"

echo "Any you want to modify something, you had better stop uwsgi first and run uwsgi again"
echo "Congratulations!"

exit


