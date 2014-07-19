#!/bin/bash
# OS: Ubuntu 14.04

# 1、确定项目路径
if [ "$#" != "2" ]; then
    echo "    Usage:(2 params) "
    echo "        $0 Project_Name Absoulte_Path_For_You_Django_Projecta"
    exit
fi

PROJECT_NAME=$1
PROJECT_PATH=$2
SCRIPT_PATH=$(pwd)
NGINX_PATH="/etc/nginx"

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
        # @TODO apt-get install uwsgi cannot success
        # sudo apt-get install -y uwsgi
        sudo pip install uwsgi
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
cp $SCRIPT_PATH"/django_wsgi.py" $PROJECT_PATH
sed -i "s%PROJECT_NAME%$PROJECT_NAME%g" $PROJECT_PATH"/django_wsgi.py"

# 4 配置文件uwsgi
cp $SCRIPT_PATH"/uwsgi.xml" $PROJECT_PATH
sed -i "s%PROJECT_PATH%$PROJECT_PATH%g" $PROJECT_PATH"/uwsgi.xml"

# 5 配置文件django.conf
nginxLogDir=$PROJECT_PATH"/logs"
if [ ! -d "$nginxLogDir" ]; then
    mkdir $nginxLogDir
fi
# cp django.conf $PROJECT_PATH
# cd $PROJECT_PATH
sudo cp $SCRIPT_PATH"/django.conf" $NGINX_PATH
sudo sed -i "s%PROJECT_PATH%$PROJECT_PATH%g" $NGINX_PATH"/django.conf"
# cd -

# 6 配置文件nginx.conf
sudo cp $SCRIPT_PATH"/nginx.conf" $NGINX_PATH

# 7 启动
ps -e | grep -i uwsgi
if [ "$?" != "0" ]; then
    killall uwsgi
fi
cd $PROJECT_PATH
uwsgi -x $PROJECT_PATH"/uwsgi.xml"
sudo /etc/init.d/nginx reload
cd -

echo "Hope you success."
echo "If NOT, TRY TO NEXT:"

echo "Now, you had better do 3 things one by one:"
echo "    1. Run: killall uwsgi"
echo "    2. Run: uwsgi -x $PROJECT_PATH/uwsgi.xml"
echo "    3. Run: sudo /etc/init.d/nginx reload"

#echo "Now, you need to reload nginx:"
#echo "    Run: sudo /etc/init.d/nginx reload"

#echo "Then: start config uwsgi: "
#echo "    Run: uwsgi $PROJECT_PATH/uwsgi.xml"

#echo "If you want to stop uwsgi: "
#echo "  You can go through the process uwsgi first"
#echo "    Run: ps -e | grep uwsgi"
#echo "  If you wantt to stop:"
#echo "    Run: killall uwsgi"

#echo "Any you want to modify something, you had better stop uwsgi first and run uwsgi again"
#echo "Congratulations!"

exit


