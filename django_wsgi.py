#!/usr/bin/env python
# coding=utf-8
import os
import sys
from django.core.handlers.wsgi import WSGIHandler

reload(sys)
sys.setdefaultencoding('utf8')

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'PROJECT_NAME.settings')

application = WSGIHandler()
