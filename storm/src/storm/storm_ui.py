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

import requests
from storm import settings, conf, utils

class StormREST(object):
	class Error(Exception):
		pass

	class NotFound(Error):
		pass

	def __init__(self, url='http://localhost:8080/api/v1'):
		self._base = url

	def _get_topologies(self):
		url = "%s%s" % (self._base, utils.TOPOLOGIES_URL)
		try:
			resp = self._get_url(url)
			return resp
		except StormREST.NotFound:
			raise

	def _get_topology(self, id, system_id=0, visualization=False, window_id=""):
		if not visualization:
			if window_id != "":
				url = "%s%s%s%s%s" % (self._base, utils.TOPOLOGY_URL, id, utils.WINDOW_ID, window_id)
			else:
				if system_id == 0:
					url = "%s%s%s" % (self._base, utils.TOPOLOGY_URL, id)
				else:
					url = "%s%s%s%s" % (self._base, utils.TOPOLOGY_URL, id, utils.SYSTEM_STATS)
		else:
			url = "%s%s%s%s" % (self._base, utils.TOPOLOGY_URL, id, utils.VISUALIZATION)
		try:
			resp = self._get_url(url)
			return resp
		except StormREST.NotFound:
			raise

	def _get_components(self, id, component_id, system_id=0):
		if system_id == 0:
			url = "%s%s%s%s%s" % (self._base, utils.TOPOLOGY_URL, id, utils.COMPONENTS, component_id)
		else:
			url = "%s%s%s%s%s%s" % (self._base, utils.TOPOLOGY_URL, id, utils.COMPONENTS, component_id, utils.SYSTEM_STATS)
		try:
			resp = self._get_url(url)
			return resp
		except StormREST.NotFound:
			raise

	def _get_cluster(self):
		url = "%s%s" % (self._base, utils.CLUSTER_URL)
		try:
			resp = self._get_url(url)
			return resp
		except StormREST.NotFound:
			raise

	def _get_supervisor(self):
		url = "%s%s" % (self._base, utils.SUPERVISOR_URL)
		try:
			resp = self._get_url(url)
			return resp
		except StormREST.NotFound:
			raise

	def _get_configuration(self):
		url = "%s%s" % (self._base, utils.CONFIGURATION_URL)
		try:
			resp = self._get_url(url)
			return resp
		except StormREST.NotFound:
			raise

	def _get_url(self, url):
		try:
			req = requests.get(url)
			resp = req.json()
			return resp
		except requests.exceptions.URLRequired as e:
			raise STORMREST.NotFound(uri)
		except requests.exceptions.HTTPError as e:
			if e.code == 404:
				raise StormREST.NotFound(uri)
			raise
		except requests.exceptions.RequestException as e:
			raise StormREST.NotFound(url)
		except:
			raise StormREST.NotFound(url)