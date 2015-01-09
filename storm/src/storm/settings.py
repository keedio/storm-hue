# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os

DJANGO_APPS = ["storm"]
REQUIRES_HADOOP = False
MENU_INDEX = 100
ICON = "/storm/static/art/icon_storm_48.png"
IS_URL_NAMESPACED = True

DEBUG = True
TEMPLATE_DEBUG = DEBUG

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
STATIC_ROOT = os.path.join(PROJECT_ROOT, 'static')
THRIFT_ROOT = os.path.join(PROJECT_ROOT, 'thrift')
                      
