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

import os
import commands
import requests
from django.template import RequestContext
from django.core.files.base import ContentFile
from django.shortcuts import render_to_response
from django.views.decorators.csrf import csrf_exempt
from django.core.files.storage import default_storage
from django.utils.translation import ugettext_lazy as _
from django.http import HttpResponse, HttpResponseRedirect
from desktop.lib.django_util import render  
from desktop.lib.exceptions_renderable import PopupException
from storm import settings
from storm import conf
from storm import utils
from storm.storm_ui import StormREST
from storm.forms import UploadFileForm, UploadFileFormHDFS 

SYSTEM_STATS = "?sys=1"
API_URL = "/api/v1"
LOG_URL_PATH = "/log?file=worker-"
STORM_UI_SERVER = "http://" + conf.STORM_UI_SERVER.get() + ":" + conf.STORM_UI_PORT.get()
STORM_UI = STORM_UI_SERVER + API_URL
TOPOLOGIES_URL = STORM_UI + conf.STORM_UI_TOPOLOGIES.get()
TOPOLOGY_URL = STORM_UI + conf.STORM_UI_TOPOLOGY.get()
CLUSTER_URL = STORM_UI + conf.STORM_UI_CLUSTER.get()
SUPERVISOR_URL = STORM_UI + conf.STORM_UI_SUPERVISOR.get()
CONFIGURATION_URL = STORM_UI + conf.STORM_UI_CONFIGURATION.get()
LOG_URL = "http://" + conf.STORM_UI_SERVER.get() + ":" + conf.STORM_UI_LOG_PORT.get() + LOG_URL_PATH

# *************************************************************************************************************************
# **********                                                                                                     **********
# **********                                                                                                     **********
# **********                                          VIEWS.                                                     **********
# **********                                                                                                     **********
# **********                                                                                                     **********
# *************************************************************************************************************************

# storm_dashboard *********************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-11-11 Jose Juan
# 002 2015-03-04 Jose Juan Include StormRest Class.
#
# Index View.
#
# @author Jose Juan
# @date 2014-11-11
# @param request, HTTPRequest.
# @return -
# @remarks -
#
def storm_dashboard(request):
    return render('storm_dashboard.mako', request, {'Data': _get_storm_dashboard(request)})
#
# storm_dashboard *********************************************************************************************************

# detail_dashboard ********************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-11-19 Jose Juan
# 002 2015-03-04 Jose Juan Include StormRest Class.
#
# Control Panel View of a topology (Dashboard).
#
# @author Jose Juan
# @date 2014-11-19
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param system_id, show/hide system stats.
# @return -
# @remarks -
#
def detail_dashboard(request, topology_id, system_id):
    return render('detail_dashboard.mako', request, { 'Data': _get_detail_dashboard(request, topology_id, system_id)})
#
# detail_dashboard ********************************************************************************************************

# topology_dashboard ******************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-12-03 Jose Juan
# 002 2015-03-05 Jose Juan Include StormRest Class.
#
# Topology Stats View Dashboard (bolts & spouts).
#
# @author Jose Juan
# @date 2014-12-03
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param window, window stats (bolts & spouts).
# @return -
# @remarks -
#
def topology_dashboard(request, topology_id, window_id): 
    return render('topology_dashboard.mako', request, {'Data': _get_topology_dashboard(request, topology_id, window_id)})
#
# topology_dashboard ******************************************************************************************************

# components_dashboard ****************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-12-03 Jose Juan
# 002 2015-03-05 Jose Juan Include StormRest Class.
#
# Components Dashboard (bolt & spout).
#
# @author Jose Juan
# @date 2014-12-03
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param component_id, component id (bolt & spout).
# @param system_id, show/hide system stats.
# @return -
# @remarks -
#
def components_dashboard(request, topology_id, component_id, system_id):     
    return render('components_dashboard.mako', request, {'Data': _get_components_dashboard(request, topology_id, component_id, system_id)})
#
# components_dashboard ****************************************************************************************************

# spouts_dashboard ********************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-12-09 Jose Juan
# 002 2015-03-05 Jose Juan Include StormRest Class.
#
# Control Panel of Spouts (Dashboard).
#
# @author Jose Juan
# @date 2014-12-09
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @return -
# @remarks -
#
def spouts_dashboard(request, topology_id):
    return render('spouts_dashboard.mako', request, {'Data': _get_spouts_dashboard(request, topology_id)})
#
# spouts_dashboard ********************************************************************************************************

# bolts_dashboard *********************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-12-09 Jose Juan
# 002 2015-03-05 Jose Juan Include StormRest Class.
#
# Control Panel of Bolts (Dashboard).
#
# @author Jose Juan
# @date 2014-12-09
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @return -
# @remarks -
#
def bolts_dashboard(request, topology_id):
    return render('bolts_dashboard.mako', request, {'Data': _get_bolts_dashboard(request, topology_id)})
#
# bolts_dashboard *********************************************************************************************************

# cluster_summary *********************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-11-19 Jose Juan
# 002 2015-03-04 Jose Juan Include StormRest Class.
#
# Storm cluster summary views.
#
# @author Jose Juan
# @date 2014-11-19
# @param request, HTTPRequest.
# @return -
# @remarks -
#
def cluster_summary(request):
  return render('cluster_summary.mako', request, {'Data': _get_cluster_summary(request)})  
#
# cluster_summary *********************************************************************************************************

# nimbus_configuration ****************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-11-19 Jose Juan
# 002 2015-03-04 Jose Juan Include StormRest Class.
#
# Nimbus settings views.
#
# @author Jose Juan
# @date 2014-11-19
# @param request, HTTPRequest.
# @return -
# @remarks -
#
def nimbus_configuration(request):
  return render('nimbus_configuration.mako', request, {'Data': _get_nimbus_configuration(request)})  
#
# nimbus_configuration ****************************************************************************************************

# topology ****************************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-11-26 Jose Juan
# 002 2015-03-05 Jose Juan Include StormRest Class.
#
# Topology Stats Windows (bolts & spouts).
#
# @author Jose Juan
# @date 2014-11-26
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param window_id, window stats (bolts & spouts).
# @return -
# @remarks -
#
def topology(request, topology_id, window_id):
    return render('topology.mako', request, {'Data': _get_topology(request, topology_id, window_id)})
#
# topology ****************************************************************************************************************

# components **************************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-11-26 Jose Juan
# 002 2015-03-06 Jose Juan Include StormRest Class.
#
# Storm Topology's Components (bolts & spouts stats).
#
# @author Jose Juan
# @date 2014-11-26
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param component_id, component (bolts & spouts).
# @return -
# @remarks -
#
def components(request, topology_id, component_id, system_id):   
    return render('components.mako', request, {'Data': _get_components(request, topology_id, component_id, system_id)})
#
# components **************************************************************************************************************

# failed ******************************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-01-08 Jose Juan
#
# Resumme of failed components.
#
# @author Jose Juan
# @date 2015-01-08
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param component_id, component id (spout&bolt).
# @param system_id, show/hide system stats.
# @return -
# @remarks -
#
def failed(request, topology_id, component_id, system_id):    
    return render('failed.mako', request, {'Data': _get_failed(request, topology_id, component_id, system_id)})  
#
# failed ******************************************************************************************************************

# *************************************************************************************************************************
# **********                                                                                                     **********
# **********                                                                                                     **********
# **********                                      FUNCTIONS.                                                     **********
# **********                                                                                                     **********
# **********                                                                                                     **********
# *************************************************************************************************************************

# _get_storm_dashboard ****************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-04 Jose Juan
#
# Index of application.
#
# @author Jose Juan
# @date 2015-03-04
# @param request, HTTPRequest.
# @return -
# @remarks -
#
def _get_storm_dashboard(request):
    iActive = 0
    iInactive = 0
    iExecutors = 0
    iWorkers = 0
    iTasks = 0

    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI
            
      if _get_error(st_ui._get_topologies()):
        raise StormREST.NotFound
      else:
          data['topologies'] = st_ui._get_topologies()
          for topology in data['topologies']['topologies']:
              topology.update({'seconds': utils._get_seconds_from_strdate(topology["uptime"]) })

              if topology["status"] == "ACTIVE":
                iActive += 1
              else:   
                iInactive += 1
           
              iExecutors += topology["executorsTotal"]
              iWorkers += topology["workersTotal"]
              iTasks += topology["tasksTotal"] 
          
          data['actives'] = iActive
          data['inactives'] = iInactive
          data['executors'] = iExecutors
          data['workers'] = iWorkers
          data['tasks'] = iTasks
          data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
          data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
          data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI, 
              'topologies': [], 
              'actives': -1, 
              'inactives': -1, 
              'executors': -1, 
              'workers': -1, 
              'tasks': -1, 
              'frmNewTopology':utils._get_newform(request, UploadFileForm),
              'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 
              'error': 1}

    return data
#   
# _get_storm_dashboard ****************************************************************************************************

# _get_detail_dashboard ***************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-04 Jose Juan
#
# Get Data for a Control Panel of a topology (Dashboard).
#
# @author Jose Juan
# @date 2015-03-04
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param system_id, show/hide system stats.
# @return -
# @remarks -
#
def _get_detail_dashboard(request, topology_id, system_id):
    aTopology = []
    aStats = []
    aSpouts = []
    aBolts = []
    aEmitted = []
    aTransferred = []
    aAcked = []
    aFailed = []
    iEmitted = 0
    iTransferred = 0
    iAcked = 0
    iFailed = 0    
    iSystem = int(system_id) if system_id is not None else 0
    aCheck = []

    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI
      
      if _get_error(st_ui._get_topologies()):
        raise StormREST.NotFound
      else:
        data['topology'] = _get_topology_info(topology_id)
        topology = st_ui._get_topology(topology_id, iSystem, False, "")
        data['system'] = 1 if (iSystem == 0) else 0      
        data['stats'] = topology['topologyStats']
        data['spouts'] = topology['spouts']
        data['bolts'] = topology['bolts']
        data['jStats'] = utils._get_dumps(topology['topologyStats'])
        data['jSpouts'] = utils._get_dumps(topology['spouts'])
        data['jBolts'] = utils._get_dumps(topology['bolts'])
        visualization = st_ui._get_topology(topology_id, 0, True, "")
        data['visualization'] = utils._get_dumps(visualization)

        for default in visualization:
          if len(visualization[default][':inputs']):
            if not (visualization[default][':inputs'][0][':stream'].startswith("__")):
              aCheck.append({'id': visualization[default][':inputs'][0][':sani-stream'], 
                             'name': visualization[default][':inputs'][0][':stream'], 
                             'check': "checked"});
              
        for check in visualization['__acker'][':inputs']:
          aCheck.append({'id': check[':sani-stream'], 'name': check[':stream'], 'check': ""});
        
        #For each element(d) in aCheck Dict, delete repeat elements.
        aCheck = [dict(t) for t in set([tuple(d.items()) for d in aCheck])]

        for stat in data['stats']:
            iEmitted+=stat["emitted"] if stat["emitted"] is not None else 0
            iTransferred+=stat["transferred"] if stat["transferred"] is not None else 0
            iAcked+=stat["acked"] if stat["acked"] is not None else 0
            iFailed+=stat["failed"] if stat["failed"] is not None else 0
         
        aEmitted.append(iEmitted)     
        aTransferred.append(iTransferred)     
        aAcked.append(iAcked)     
        aFailed.append(iFailed)     
        iEmitted = 0
        iTransferred = 0
        iAcked = 0
        iFailed = 0
         
        for spout in data['spouts']:
            iEmitted+=spout["emitted"] if spout["emitted"] is not None else 0
            iTransferred+=spout["transferred"] if spout["transferred"] is not None else 0
            iAcked+=spout["acked"] if spout["acked"] is not None else 0
            iFailed+=spout["failed"] if spout["failed"] is not None else 0
         
        aEmitted.append(iEmitted)     
        aTransferred.append(iTransferred)     
        aAcked.append(iAcked)     
        aFailed.append(iFailed)
        iEmitted = 0
        iTransferred = 0
        iAcked = 0
        iFailed = 0
         
        for bolt in data['bolts']:
            iEmitted+=bolt["emitted"] if bolt["emitted"] is not None else 0
            iTransferred+=bolt["transferred"] if bolt["transferred"] is not None else 0
            iAcked+=bolt["acked"] if bolt["acked"] is not None else 0
            iFailed+=bolt["failed"] if bolt["failed"] is not None else 0
           
        aEmitted.append(iEmitted)     
        aTransferred.append(iTransferred)     
        aAcked.append(iAcked)     
        aFailed.append(iFailed)                

        data['emitted'] = aEmitted     
        data['transferred'] = aTransferred
        data['acked'] = aAcked
        data['failed'] = aFailed
        data['aCheck'] = aCheck
        data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
        data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
        data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI, 
              'topology': _get_topology_info(topology_id), 
              'system': -1, 
              'stats': [], 
              'spouts': [], 
              'bolts': [], 
              'jStats': [], 
              'jSpouts': [], 
              'jBolts': [], 
              'visualization': [], 
              'emitted': [], 
              'transferred': [], 
              'acked': [], 
              'failed': [], 
              'aCheck': [],
              'frmNewTopology':utils._get_newform(request, UploadFileForm),
              'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 
              'error': 1}
     
    return data
#
# _get_detail_dashboard ***************************************************************************************************

# _get_topology_dashboard *************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-05 Jose Juan
#
# Get data of Topology Stats Dashboard (bolts & spouts).
#
# @author Jose Juan
# @date 2015-03-05
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param window, window stats (bolts & spouts).
# @return -
# @remarks -
#
def _get_topology_dashboard(request, topology_id, window_id):
    aTopology = []

    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI

      if _get_error(st_ui._get_topologies()):
        raise StormREST.NotFound
      else:
        data['topology'] = _get_topology_info(topology_id)
        topologyStats = st_ui._get_topology(topology_id, 0, False, window_id)  
        topology = st_ui._get_topology(topology_id, 0, False, "")  
        data['jStats'] = utils._get_dumps(topologyStats['topologyStats'])
        data['jSpouts'] = utils._get_dumps(topologyStats['spouts'])
        data['jBolts'] = utils._get_dumps(topologyStats['bolts'])
        data['spouts'] = topology['spouts']
        data['bolts'] = topology['bolts']
        data['window_id'] = window_id
        data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
        data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
        data['error'] = 0
    except StormREST.NotFound:
        data = {'storm_ui': utils.STORM_UI, 
                'jStats': [], 
                'jSpouts': [], 
                'jBolts': [], 
                'topology': _get_topology_info(topology_id),
                'spouts': [],
                'bolts': [],
                'window_id': -1,    
                'frmNewTopology':utils._get_newform(request, UploadFileForm),
                'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 
                'error': 1}

    return data
#
# _get_topology_dashboard *************************************************************************************************

# _get_components_dashboard ***********************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-05 Jose Juan
#
# Get data of Components Dashboard (bolt & spout).
#
# @author Jose Juan
# @date 2015-03-05
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param component_id, component id (bolt & spout).
# @param system_id, show/hide system stats.
# @return -
# @remarks -
#
def _get_components_dashboard(request, topology_id, component_id, system_id):
    iSystem = int(system_id) if system_id is not None else 0
    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI

      if _get_error(st_ui._get_topologies()):
        raise StormREST.NotFound
      else:
          topology = st_ui._get_topology(topology_id, iSystem, False, "")
          data['components'] = st_ui._get_components(topology_id, component_id, 0)
          
          if data['components']['componentType'] == "bolt":
            data['jComponents'] = utils._get_dumps(data['components']["boltStats"])
          else:
            data['jComponents'] = utils._get_dumps(data['components']["spoutSummary"])

          data['system'] = 1 if (iSystem == 0) else 0
          data['topology'] = _get_topology_info(topology_id)
          data['component_id'] = component_id
          data['spouts'] = topology['spouts']
          data['bolts'] = topology['bolts']
          try:
            data['input'] = utils._get_dumps(data['components']['inputStats'])
          except:
            data['input'] = []
          try:
            data['output'] = utils._get_dumps(data['components']['outputStats'])
          except:  
            data['output'] = []
          try:
            data['executor'] = utils._get_dumps(data['components']['executorStats'])
          except:  
            data['executor'] = []
          try:
            data['errors'] = utils._get_dumps(data['components']['componentErrors'])
          except:  
            data['errors'] = []    

          data['jSpouts'] = utils._get_dumps(topology['spouts'])
          data['jBolts'] = utils._get_dumps(topology['bolts'])

          data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
          data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
          data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI, 
              'components': [], 
              'jComponents': [], 
              'system': -1, 
              'topology': _get_topology_info(topology_id),
              'component_id': -1,  
              'spouts': [], 
              'bolts': [], 
              'input': [],
              'output': [],
              'errors': [], 
              'jSpouts': [], 
              'jBolts': [],   
              'frmNewTopology':utils._get_newform(request, UploadFileForm),
              'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 
              'error': 1}

    return data
#
# _get_components_dashboard ***********************************************************************************************

# _get_spouts_dashboard ********************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-05 Jose Juan
#
# Control Panel View  of Spouts (Dashboard).
#
# @author Jose Juan
# @date 2015-03-2015
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @return -
# @remarks -
#
def _get_spouts_dashboard(request, topology_id):
    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI

      if _get_error(st_ui._get_topologies()):
        raise StormREST.NotFound
      else:
        topology = st_ui._get_topology(topology_id, 0, False, "")
        data['topology'] = _get_topology_info(topology_id)
        data['spouts'] = topology['spouts']
        data['bolts'] = topology['bolts']
        data['jSpouts'] = utils._get_dumps(topology['spouts'])
        data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
        data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
        data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI, 
              'topology': _get_topology_info(topology_id), 
              'spouts': [],
              'bolts': [],  
              'jSpouts': [], 
              'frmNewTopology':utils._get_newform(request, UploadFileForm),
              'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 
              'error': 1}
     
    return data
#
# _get_spouts_dashboard ***************************************************************************************************

# _get_bolts_dashboard *********************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-05 Jose Juan
#
# Control Panel View of Bolts (Dashboard).
#
# @author Jose Juan
# @date 2015-03-05
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @return -
# @remarks -
#
def _get_bolts_dashboard(request, topology_id):
    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI

      if _get_error(st_ui._get_topologies()):
        raise StormREST.NotFound
      else:
        topology = st_ui._get_topology(topology_id, 0, False, "")
        data['topology'] = _get_topology_info(topology_id)
        data['spouts'] = topology['spouts']
        data['bolts'] = topology['bolts']
        data['jBolts'] = utils._get_dumps(topology['bolts'])
        data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
        data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
        data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI, 
              'topology': _get_topology_info(topology_id), 
              'spouts': [], 
              'bolts': [], 
              'jBolts': [], 
              'frmNewTopology':utils._get_newform(request, UploadFileForm),
              'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 
              'error': 1}
     
    return data
#
# _get_bolts_dashboard ****************************************************************************************************

# _get_cluster_summary ****************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-04 Jose Juan
#
# Get summary data from the Storm Cluster.
#
# @author Jose Juan
# @date 2015-03-04
# @param request, HTTPRequest.
# @return -
# @remarks -
#
def _get_cluster_summary(request):
    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI

      if _get_error(st_ui._get_topologies()):
        raise StormREST.NotFound
      else:
        data['cluster'] = st_ui._get_cluster()
        data['supervisor'] = st_ui._get_supervisor()
        data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
        data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
        data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI, 'cluster':[],'supervisor':{'supervisors':[]},'frmNewTopology':utils._get_newform(request, UploadFileForm),'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 'error':1}

    return data
#
# _get_cluster_summary ****************************************************************************************************

# _get_nimbus_configuration ***********************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-04 Jose Juan
#
# Get Nimbus Configuration from th Storm Cluster.
#
# @author Jose Juan
# @date 2015-03-04
# @param request, HTTPRequest.
# @return -
# @remarks -
#
def _get_nimbus_configuration(request):
    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI

      if _get_error(st_ui._get_topologies()):
        raise StormREST.NotFound
      else:
        data['configuration'] = st_ui._get_configuration()
        data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
        data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
        data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI, 'configuration':[],'frmNewTopology':utils._get_newform(request, UploadFileForm),'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 'error': 1}

    return data
#
# _get_nimbus_configuration ***********************************************************************************************

# _get_topology ***********************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-05 Jose Juan
#
# Get data of Topology Stats Windows (bolts & spouts).
#
# @author Jose Juan
# @date 2015-03-05
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param window_id, window stats (bolts & spouts).
# @return -
# @remarks -
#
def _get_topology(request, topology_id, window_id):
    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI
      topology = st_ui._get_topology(topology_id, 0, False, window_id)  
      topologyStats = topology['topologyStats']

      for element in topologyStats:
        if element["window"] == window_id:
            data['stats'] = element   

      data['topology'] = _get_topology_info(topology_id)
      data['spouts'] = topology['spouts']
      data['bolts'] = topology['bolts']
      data['system'] = 0
      data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
      data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
      data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI, 
              'topology':_get_topology_info(topology_id),
              'stats':[],
              'spouts':[],
              'bolts':[],
              'system':-1,
              'frmNewTopology':utils._get_newform(request, UploadFileForm),
              'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 
              'error': 1}

    return data
#
# _get_topology ***********************************************************************************************************

# _get_components *********************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-06 Jose Juan
#
# Get data of Storm Topology's Components (bolts & spouts stats).
#
# @author Jose Juan
# @date 2015-03-06
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param component_id, component (bolts & spouts).
# @return -
# @remarks -
#
def _get_components(request, topology_id, component_id, system_id): 
    iSystem = int(system_id) if system_id is not None else 0
    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      data['storm_ui'] = utils.STORM_UI

      if _get_error(st_ui._get_topologies()):
        raise StormREST.NotFound
      else:
          topology = st_ui._get_topology(topology_id, iSystem, False, "")
          data['components'] = st_ui._get_components(topology_id, component_id, system_id)
          data['system'] = 1 if (iSystem == 0) else 0
          data['topology'] = _get_topology_info(topology_id)
          data['component_id'] = component_id
          try:
            data['input'] = data['components']['inputStat']
          except:
            data['input'] = []
          try:
            data['output'] = data['components']['outputStats']
          except:  
            data['output'] = []
          try:
            data['executor'] = data['components']['executorStats']
          except:  
            data['executor'] = []
          try:
            data['errors'] = data['components']['componentErrors']
          except:  
            data['errors'] = []    

          data['log_url'] = utils.LOG_URL
          data['frmNewTopology'] = utils._get_newform(request, UploadFileForm)
          data['frmHDFS'] = utils._get_newform(request, UploadFileFormHDFS)
          data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI, 
              'components': [], 
              'system': -1, 
              'topology': _get_topology_info(topology_id),
              'component_id': -1,  
              'input': [],
              'output': [],
              'error': [],    
              'log_url': "",
              'frmNewTopology':utils._get_newform(request, UploadFileForm),
              'frmHDFS':utils._get_newform(request, UploadFileFormHDFS), 
              'error': 1}
     
    return data
#
# _get_components *********************************************************************************************************

# _get_failed *************************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-05 Jose Juan
#
# Get data of failed components.
#
# @author Jose Juan
# @date 2015-03-05
# @param request, HTTPRequest.
# @param topology_id, topology id.
# @param component_id, component id (spout&bolt).
# @param system_id, show/hide system stats.
# @return -
# @remarks -
#
def _get_failed(request, topology_id, component_id, system_id): 
    try:
      st_ui = StormREST(utils.STORM_UI)      
      data = {}
      iSystem = int(system_id) if system_id is not None else 0
      topology = st_ui._get_topology(topology_id, iSystem, False, "")
      data['topology'] = _get_topology_info(topology_id)
      data['spouts'] = topology['spouts']
      data['bolts'] = topology['bolts']
      data['stats'] = topology['topologyStats']
      data['component_id'] = component_id
      data['error'] = 0
    except StormREST.NotFound:
      data = {'storm_ui': utils.STORM_UI,
              'topology':_get_topology_info(topology_id),
              'spouts':[], 
              'bolts':[],
              'stats':[],
              'error': 1}

    return data
#
# failed ******************************************************************************************************************

# changeTopologyStatus ****************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-11-25 Jose Juan
#
# Activa una topología del clúster STORM.
#
# @author Jose Juan
# @date 2014-11-25
# @param request, HTTPRequest.
# @return -
# @remarks -
#
@csrf_exempt
def changeTopologyStatus(request):
    iResult = -1
    sId = ""
    sAction = ""
    bWait = False
    iWait = -1    
  
    try:
        if request.method == 'POST':
            sId = request.POST['sId']      
            sAction = request.POST['sAction']
            bWait = request.POST['bWait']
            iWait = request.POST['iWait']
     
            if (bWait == "true"):
                post_response = requests.post(TOPOLOGY_URL + sId + '/' + sAction + '/' + iWait)            
            else:
                post_response = requests.post(TOPOLOGY_URL + sId + '/' + sAction)                                    
      
            iResult =  post_response.status_code               
    except requests.exceptions.URLRequired as e:
        iResult = e
    except requests.exceptions.HTTPError as e:
        iResult = e
    except requests.exceptions.RequestException as e:
        iResult = e
    except:
        iResult = 1
       
    return HttpResponse(iResult, mimetype = "application/javascript") 
#
# changeTopologyStatus ****************************************************************************************************
    
# set_topology_status *****************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-11-25 Jose Juan
# 001 2015-01-20 Jose Juan (Add submit topology)
#
# Management of Storm Topology.
#
# @author Jose Juan
# @date 2014-11-25
# @param request, HTTPRequest.
# @return -
# @remarks -
#
@csrf_exempt
def set_topology_status(request):  
    sAction = ""   
    sExecute = ""
    iNumWorkers = 0
    sOptions = ""
    sWaitSecs = ""
    sNumWorkers = ""
    sNumExecutors = ""
    msg = ""
    sTopologyName = ""
    response = {'status': -1, 'output': -1, 'data': ''}  
    sScript = "storm"                           

    if request.method == 'POST':
        sAction = request.POST['psAction']             
          
        if sAction == "rebalance":                   
            sNameTopology = request.POST['psNameTopology'] 
            iNumWorkers = request.POST['piNumWorkers'] if (request.POST['piNumWorkers'] != "") else 0                        
            iWaitSecs = request.POST['piWaitSecs'] if (request.POST['piWaitSecs'] != "") else 0                        
            aComponent = request.POST.getlist('paComponents[]')
            
            if (iWaitSecs > 0):
                sOptions += " -w " + iWaitSecs        
	  
            if (iNumWorkers > 0):
                sOptions += " -n " + iNumWorkers
            
            iMod = 0
            
            if aComponent != []:    
                while (iMod < len(aComponent)):
                    if(iMod%2 == 0):     
                        sOptions += " -e " + aComponent[iMod] + "="
                    else:                           
                        sOptions+=aComponent[iMod]
                        
                    iMod+=1
                
            sExecute = sScript + " " + sAction + " " + sNameTopology + " " + sOptions                                
                    
        if sAction == "submitTopology":            
            sURL = request.POST['psURL']
            form = UploadFileForm(request.POST, request.FILES)

            if form.is_valid():                                            
                sServer = conf.STORM_UI_SERVER.get()                       
                sClass = request.POST['class_name'] if (request.POST['class_name'] != "") else ""
                sTopologyName = request.POST['topology_name'] if (request.POST['topology_name'] != "") else ""
                sFile = request.FILES['file']
                sFileName = sFile.name                                                        
                sClass = request.POST['class_name']  
                sPath = settings.UPLOAD_ROOT + '/' + sFileName
                    
                if not os.path.isfile(sPath):
                    path = default_storage.save(settings.UPLOAD_ROOT + '/' + sFileName, ContentFile(sFile.read()))
                    sPath = os.path.join(settings.UPLOAD_ROOT, path)
                    
                sExecute = sScript + " " + "jar -c nimbus.host=" + sServer + " " + sPath + " " + sClass + " " + sTopologyName
                response['status'] = 0
                        
            else:
                #raise PopupException(_("Error in upload form: %s") % (form.errors,))
                msg = _("Error in upload form: %s.\n") % form.errors
                response['error'] = form.errors
                response['status'] = -1
              
        if sAction == "saveTopology":
            sURL = request.POST['psURL']
            form = UploadFileFormHDFS(request.POST, request.FILES)
            
            if request.META.get('upload_failed'):
                raise PopupException(request.META.get('upload_failed'))
            
            try:
                sFileHDFS = request.FILES['hdfs_file']
            except:
                sFileHDFS = ""
            
            try:    
                if sFileHDFS != "":
                    username = request.user.username
                    sFileNameHDFS = sFileHDFS.name
                    sPathHDFS = "/user/" + username                 
                    sPathHDFS = request.fs.join(sPathHDFS, sFileNameHDFS)                    
                    tmp_file = sFileHDFS.get_temp_path()
                    request.fs.do_as_user(username, request.fs.rename, tmp_file, sPathHDFS)                        
                    
                    return HttpResponseRedirect(sURL)
                else:        
                    msg = _('HDFS File must not be empty.\n')
                    raise PopupException(msg)
                           
            except IOError, ex:
                already_exists = False
                response['status'] = -1
                    
                try:
                    already_exists = request.fs.exists(sPathHDFS)
                except Exception:
                    pass
         
                if already_exists:
                    msg = _('Destination %(name)s already exists.\n')  % {'name': sPathHDFS}
                else:
                    msg = _('Copy to %(name)s failed: %(error)s.\n') % {'name': sPathHDFS, 'error': ex}    
                
                raise PopupException(msg)
                          
    status, output = commands.getstatusoutput(sExecute)      
  
    response['output'] = output
            
    if sAction == "submitTopology":
        try:
            os.remove(sPath)
        except:
            msg += "Exception raised while deleting temp file.\n"
        pass

        if ("Finished submitting topology: " + sTopologyName) in response['output']:
            output = None
            
        if (output is None) and (response['status'] == 0):
            return HttpResponseRedirect(sURL)
        else:
            if output is None:
                msg += "Topology submitted OK.\n"
            else:
                msg += "Error submitting topology.\n"
                    
            raise PopupException(msg)
            
    return HttpResponse(json.dumps(response), content_type="text/plain")            
#
# set_topology_status ***************************************************************************************************** 

# _get_error **************************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-03-06 Jose Juan
#
# Check if exists error in requests to Storm-UI.
#
# @author Jose Juan
# @date 2015-03-06
# @param psObject, form.
# @return New class form.
# @remarks -
#
def _get_error(psList):
    try:        
        bOk = psList['errorMessage'] != ""
    except:
        bOk = False

    return bOk
#
# _get_error **************************************************************************************************************

# _get_topology_info ******************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2014-12-03 Jose Juan
#
# Storm Topology's.
#
# @author Jose Juan
# @date 2014-12-03
# @param topology_id, Topology Id.
# @return Array with topology status.
# @remarks -
#
def _get_topology_info(topology_id):    
    try:
      st_ui = StormREST(utils.STORM_UI)
      data = {}
      topology = st_ui._get_topology(topology_id, 0, False)
      data['name'] = topology["name"]
      data['id'] = topology["id"]
      data['status'] = topology["status"]
      data['uptime'] = topology["uptime"]
      data['workers'] = topology["workersTotal"]
      data['executors'] = topology["executorsTotal"]
      data['tasks'] = topology["tasksTotal"]
      data['error'] = 0
    except:
      data = {'name': "",
              'id': "",
              'status': "",
              'uptime': "",
              'workers': -1,
              'executors': -1,
              'tasks': -1, 
              'error': "",
              'error': 1 }

    return data
#
# _get_topology_info ******************************************************************************************************
