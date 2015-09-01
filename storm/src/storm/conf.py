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

from desktop.lib.conf import Config
from django.utils.translation import ugettext_lazy as _t, ugettext as _

STORM_UI_SERVER = Config(
	key="storm_ui_server",
	help="Storm-UI Server",
	default="localhost",
	type=str)
                      
STORM_UI_PORT = Config( 
	key="storm_ui_port",
	help="STORM-UI PORT",
	default="8080",
	type=str)

STORM_UI_LOG_PORT = Config(
	key="storm_ui_log_port",
	help="STORM-UI LOG PORT",
	default="8000",
	type=str)
			
STORM_UI_CLUSTER = Config(
	key="storm_ui_cluster",
	help="Path to cluster info summary, e.g. /cluster/summary",
	default="/cluster/summary",
	type=str)

STORM_UI_SUPERVISOR = Config(
	key="storm_ui_supervisor",
	help="Path to supervisor info summary, e.g. /supervisor/summary",
	default="/supervisor/summary",
	type=str)
			
STORM_UI_TOPOLOGIES = Config(
	key="storm_ui_topologies",
	help="Path to resume of all topologies, e.g. /topology/summary",
	default="/topology/summary",
	type=str)
			
STORM_UI_TOPOLOGY = Config(
	key="storm_ui_topology",
	help="Path to topology info summary, e.g. /topology",
	default="/topology/",
	type=str)

STORM_UI_CONFIGURATION = Config(
	key="storm_ui_configuration",
	help="Path to cluster configuration, e.g. /cluster/configuration",
	default="/cluster/configuration",
	type=str)

def config_validator(user):
	res = []
	
	if not STORM_UI_SERVER.get():
		res.append((STORM_UI_SERVER, _("You must to specify STORM UI Server I.P. or STORM UI Server HostName.")))

	if not STORM_UI_PORT.get():
		res.append((STORM_UI_PORT, _("You must to specify STORM UI Server port.")))

	if not STORM_UI_LOG_PORT.get():
		res.append((STORM_UI_LOG_PORT, _("You must to specify LogViewer URL to view the nimbus.log.")))

	if not STORM_UI_CLUSTER.get():
		res.append((STORM_UI_CLUSTER, _("You must to specify a STORM-UI Cluster Summary path.")))

	if not STORM_UI_SUPERVISOR.get():
		res.append((STORM_UI_SUPERVISOR, _("You must to specify a STORM-UI Supervisor Summary path.")))

	if not STORM_UI_TOPOLOGIES.get():
		res.append((STORM_UI_TOPOLOGIES, _("You must to specify a STORM-UI Topologies Summary path.")))

	if not STORM_UI_TOPOLOGY.get():
		res.append((STORM_UI_TOPOLOGY, _("You must to specify a STORM-UI Topology path.")))

	if not STORM_UI_CONFIGURATION.get():
		res.append((STORM_UI_CONFIGURATION, _("You must to specify a STORM-UI Configuration path.")))

	return res
