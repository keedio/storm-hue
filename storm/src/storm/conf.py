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

from desktop.lib.conf import Config, ConfigSection

SERVER = ConfigSection(
            'server', 
            help = "Information about a STORM CLUSTER (Information returns like JSON elements)",
            members = dict(        
                         STORM_UI = Config( "storm_ui",
                                            help="URL to STORM UI",
                                            default="http://vm2:8080/api/v1",
                                            type=str,
                                          ),
			 STORM_UI_LOG = Config( "storm_ui_log",
                                                help="URL to STORM UI LOG",
                                                default="http://vm2:8000/log?file=worker-",
                                                type=str,
                                              ),
			 STORM_UI_CLUSTER = Config( "storm_ui_cluster",
                                                    help="Path to cluster info summary, e.g. /cluster/summary",
                                                    default="/cluster/summary",
                                                    type=str,
                                                  ),
			 STORM_UI_SUPERVISOR = Config( "storm_ui_supervisor",
                                                       help="Path to supervisor info summary, e.g. /supervisor/summary",
                                                       default="/supervisor/summary",
                                                       type=str,
                                                     ),
			 STORM_UI_TOPOLOGIES = Config( "storm_ui_topologies",
                                                       help="Path to resume of all topologies, e.g. /topology/summary",
                                                       default="/topology/summary",
                                                       type=str,
                                                     ),
			 STORM_UI_TOPOLOGY = Config( "storm_ui_topology",
                                                     help="Path to topology info summary, e.g. /topology",
                                                     default="/topology/",
                                                     type=str,
                                                   ),
			 STORM_UI_CONFIGURATION = Config( "storm_ui_configuration",
                                                          help="Path to cluster configuration, e.g. /cluster/configuration",
                                                          default="/cluster/configuration",
                                                          type=str,
                                                        ),
        
                      )
         )