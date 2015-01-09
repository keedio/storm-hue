#encoding:utf-8

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

from django.conf.urls.defaults import patterns, url

IS_URL_NAMESPACED = True

urlpatterns = patterns('storm.views',
  #Storm's Dashboard.  
  url(r'^$', 'storm_dashboard', name = "storm_dashboard"),
  url(r'^detail_dashboard/(?P<topology_id>.+)/(?P<system_id>.+)/$', 'detail_dashboard', name = "detail_dashboard"),
  url(r'^topology_dashboard/(?P<topology_id>.+)/(?P<window_id>.+)/$', 'topology_dashboard', name = "topology_dashboard"),
  url(r'^components_dashboard/(?P<topology_id>.+)/(?P<component_id>.+)/(?P<system_id>.+)/$', 'components_dashboard', name = "components_dashboard"),
  url(r'^spouts_dashboard/(?P<topology_id>.+)/$', 'spouts_dashboard', name = "spouts_dashboard"),     
  url(r'^bolts_dashboard/(?P<topology_id>.+)/$', 'bolts_dashboard', name = "bolts_dashboard"), 
  #Cluster Summary.  
  url('cluster_summary/$', 'cluster_summary', name = "cluster_summary"),  
  #Topology Summary.  
  url('nimbus_configuration/$', 'nimbus_configuration', name = "nimbus_configuration"),
  #Topology Stats.   
  url(r'^topology/(?P<topology_id>.+)/(?P<window_id>.+)/$', 'topology', name = "topology"),
  #Components.   
  url(r'^components/(?P<topology_id>.+)/(?P<component_id>.+)/(?P<system_id>.+)/$', 'components', name = "components"),
  #Failed Summary.  
  url('failed/(?P<topology_id>.+)/(?P<component_id>.+)/(?P<system_id>.+)/$', 'failed', name = "failed"),  
  #Change status of a topology.
  url(r'^changeTopologyStatus/$','changeTopologyStatus', name= "changeTopologyStatus"),
  url(r'^set_topology_status/$','set_topology_status', name= "set_topology_status"),    
)
