#encoding:utf-8

#!/usr/bin/env python
## Licensed to the Apache Software Foundation (ASF) under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  The ASF licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
## http:# www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

try:
    import simplejson as json
except ImportError:
    import json

from storm import conf

SYSTEM_STATS = "?sys=1"
WINDOW_ID = "?window="
COMPONENTS = "/component/"
VISUALIZATION = "/visualization"
API_URL = "/api/v1"
LOG_URL_PATH = "/log?file=worker-"
STORM_UI_SERVER = "http://" + conf.STORM_UI_SERVER.get() + ":" + conf.STORM_UI_PORT.get()
STORM_UI = STORM_UI_SERVER + API_URL
TOPOLOGIES_URL = conf.STORM_UI_TOPOLOGIES.get()
TOPOLOGY_URL = conf.STORM_UI_TOPOLOGY.get()
CLUSTER_URL = conf.STORM_UI_CLUSTER.get()
SUPERVISOR_URL = conf.STORM_UI_SUPERVISOR.get()
CONFIGURATION_URL = conf.STORM_UI_CONFIGURATION.get()
LOG_URL = "http://" + conf.STORM_UI_SERVER.get() + ":" + conf.STORM_UI_LOG_PORT.get() + LOG_URL_PATH

# _get_newform ************************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-12-29 Jose Juan
#
# Get new form.
#
# @author Jose Juan
# @date 2014-12-29
# @param psObject, form.
# @return New class form.
# @remarks -
#
def _get_newform(request, pfForm):
    if request.method == 'POST':
        form = pfForm(request.POST, request.FILES)
    else:   
        form = pfForm()
     
    return form
#
# _get_newform ************************************************************************************************************

# _get_dumps **************************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-12-23 Jose Juan
#
# Convert string literal to raw string literal.
#
# @author Jose Juan
# @date 2014-12-23
# @param psObject, string literal.
# @return raw string literal.
# @remarks -
#
def _get_dumps(psObject):
	jsonDumps = json.dumps(psObject).replace("\\", "\\\\")

	return jsonDumps
#
# _get_dumps **************************************************************************************************************

# _get_seconds_from_strdate ***********************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-12-11 Jose Juan
#
# Get seconds from a date in string type.
#
# @author Jose Juan
# @date 2014-12-11
# @param psDate, Topology Id.
# @return Array with topology status.
# @remarks -
#
def _get_seconds_from_strdate(psDate):
	iSeconds = 0
	
	try:
		aDate = psDate.split(" ")
		iLen = len(aDate) if len(psDate) is not None else 0
	except:
		iLen = 0

	if iLen == 1:
		try:
			iSeconds = int(aDate[0][:-1])
		except:
			iSeconds = 0    

	elif iLen == 2:
		try:
			iSeconds = (int(aDate[0][:-1]) * 60) + int(aDate[1][:-1])
		except:
			iSeconds = 0    

	elif iLen == 3:
		try:
			iSeconds = (int(aDate[0][:-1]) * 3600) + (int(aDate[1][:-1]) * 60) + int(aDate[2][:-1])
		except:
			iSeconds = 0

	elif iLen == 4:
		try:
			iSeconds = (int(aDate[0][:-1]) * 86400) + (int(aDate[1][:-1]) * 3600) + (int(aDate[2][:-1]) * 60) + int(aDate[3][:-1])
		except:
			iSeconds = 0

	else:
		iSeconds = 0

	return iSeconds
#  
# _get_seconds_from_strdate ************************************************************************************************
