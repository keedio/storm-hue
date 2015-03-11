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

<%!
   from desktop.views import commonheader, commonfooter
   from django.utils.translation import ugettext as _
   from django import forms
%>

<!-- Div, if show it if there are not data. -->
<%def name="divWithoutData()">
   <div class="container-fluid">
      <div class="card">        
         <div class="card-body">            
            <div class="alert alert-warning">            
               <h3>${ _('No active topologies available') }</h3>
            </div>
         </div>
      </div>
   </div> 
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- Control Panel Topology. Control buttons of a topology. Direct access to dashboards. -->
<%def name="ControlPanelTopology(paTopology, sURL)">
   <tr>                          
      <td align="left">                               
         <span class="btn-group">            
            % if paTopology['status'] == "INACTIVE":
               <button id="btnActivate" data-target="#tblActivate" class="btn" data-toggle="modal"><i class="fa fa-play"></i> ${ _('Activate') } </button>
            % else:
               <button id="btnDeactivate" data-target="#tblDeactivate" class="btn" data-toggle="modal"><i class="fa fa-stop"></i> ${ _('Deactivate') } </button>
            % endif            
            <div class="btn-toolbar" style="display: inline; vertical-align: middle">
               <div id="upload-dropdown" class="btn-group" style="vertical-align: middle">
                  <a href="#" class="btn upload-link dropdown-toggle" title="${ _('Rebalance') }" data-toggle="dropdown">
                     <i class="fa fa-refresh"></i> ${ _('Rebalance') }
                     <span class="caret"></span>
                  </a>
                  <ul class="dropdown-menu">
                     <li><a href="#" data-target="#tblAutomaticRebalance" class="btn" data-toggle="modal"><i class="fa fa-refresh"></i> ${ _('Automatic') } </a></li>                                          
                     <li><a href="#" data-target="#tblRebalanceTopology" class="btn" data-toggle="modal"><i class="fa fa-cog"></i> ${ _('Custom') } </a></li>                     
                  </ul>
               </div>
            </div> 
            <button id="btnKill" data-target="#tblKill" class="btn" data-toggle="modal"><i class="fa fa-trash-o"></i> ${ _('Kill') } </button>         
         </span>  
      </td>
      <td align="right">      
         <span class="btn-group">            
            % if (sURL == "detail_dashboard"):
               % if Data['system'] == 0:
                  <a href="${url('storm:detail_dashboard', topology_id = paTopology['id'], system_id = Data['system'])}" class="btn" title="${ _('Hide System Stats') }"><i class="fa fa-check-square-o"></i> ${ _('Hide System Stats') } </a>                   
               % else:
                  <a href="${url('storm:detail_dashboard', topology_id = paTopology['id'], system_id = Data['system'])}" class="btn" title="${ _('Show System Stats') }"><i class="fa fa-square-o"></i> ${ _('Show System Stats') } </a>                   
               % endif
            
               <button id="btnTables" class="btn" onclick="changeDisplay('divTables', 'divDashboard')"><i class="fa fa-table"></i> ${ _('Tables') } </button>
            % endif                                                                      
            
            % if (sURL == "components"):
               % if Data['system'] == 0:
                  <a href="${url('storm:components', topology_id = paTopology['id'], component_id = idComponent, system_id = Data['system'])}" class="btn" title="${ _('Hide System Stats') }"><i class="fa fa-check-square-o"></i> ${ _('Hide System Stats') } </a>                   
               % else:
                  <a href="${url('storm:components_dashboard', topology_id = paTopology['id'], component_id = idComponent, system_id = Data['system'])}" class="btn" title="${ _('Show System Stats') }"><i class="fa fa-square-o"></i> ${ _('Show System Stats') } </a>                   
               % endif
            % endif
            
            <div class="btn-toolbar" style="display: inline; vertical-align: middle">
               <div id="upload-dropdown" class="btn-group" style="vertical-align: middle">
                  <a href="#" class="btn upload-link dropdown-toggle" title="${ _('Dashboard') }" data-toggle="dropdown">
                     <i class="fa fa-tachometer"></i> ${ _('Dashboard') }
                     <span class="caret"></span>
                  </a>
                  <ul class="dropdown-menu">
                     <li><a href="${url('storm:detail_dashboard', topology_id = paTopology['id'], system_id = 0)}" class="btn" title="${ _('Detail') }"><i class="fa fa-tachometer"></i> ${ _('Detail') } </a></li>
                     <li><a href="${url('storm:spouts_dashboard', topology_id = paTopology['id'])}" class="btn" title="${ _('Spouts') }"><i class="fa fa-tachometer"></i> ${ _('Spouts') } </a></li>
                     <li><a href="${url('storm:bolts_dashboard', topology_id = paTopology['id'])}" class="btn" title="${ _('Bolts') }"><i class="fa fa-tachometer"></i> ${ _('Bolts') } </a></li>
                  </ul>
               </div>
            </div>          
         </span>          
      </td>
   </tr>
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- Table of Supervisor of Topology. -->
<%def name="tblSupervisor()">
   <div class="col-lg-4">
      <div class="panel panel-default">
         <div class="panel-heading">
            <i class="fa fa-table fa-fw"></i> ${ _('Supervisor Summary') }
         </div>
         <div class="panel-body">                      
            <table class="table datatables table-striped table-hover table-condensed" id="tblSupervisor" data-tablescroller-disable="true">
               <thead>
                  <tr>
                     <th>${ _('Id.') }</th> 
                     <th>${ _('Host') }</th>
                     <th>${ _('Uptime') }</th>
                     <th>${ _('Slots') }</th>
                     <th>${ _('Used slots') }</th>
                  </tr>
               </thead>
               <tbody>
                  % for row in Data["supervisor"]["supervisors"]:
                     <tr>
                        <td>${row["id"]}</td>
                        <td>${row["host"]}</td>
                        <td>${row["uptime"]}</td>
                        <td>${row["slotsTotal"]}</td>
                        <td>${row["slotsUsed"]}</td>                            
                     </tr>
                  % endfor
               </tbody>
            </table>
         </div>
      </div>
   </div>   
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- Table of Cluster of Topology. -->
<%def name="tblCluster()">
   <div class="col-lg-4">
      <div class="panel panel-default">
         <div class="panel-heading">
            <i class="fa fa-table fa-fw"></i> ${ _('Cluster Summary') }
         </div>
         <div class="panel-body">
            <table class="table datatables table-striped table-hover table-condensed" id="tblCluster" data-tablescroller-disable="true">
               <thead>
                  <tr>
                     <th>${ _('Version') }</th> 
                     <th>${ _('Nimbus uptime') }</th>
                     <th>${ _('supervisors') }</th>
                     <th>${ _('Used slots') }</th>
                     <th>${ _('Free slots') }</th> 
                     <th>${ _('Total slots') }</th>
                     <th>${ _('Executors') }</th>
                     <th>${ _('Tasks') }</th>
                  </tr>
               </thead>
               <tbody>                      
                  <tr>
                     <td>${Data["cluster"]["stormVersion"]}</td>
                     <td>${Data["cluster"]["nimbusUptime"]}</td>
                     <td>${Data["cluster"]["supervisors"]}</td>
                     <td>${Data["cluster"]["slotsUsed"]}</td>
                     <td>${Data["cluster"]["slotsFree"]}</td>
                     <td>${Data["cluster"]["slotsTotal"]}</td>
                     <td>${Data["cluster"]["executorsTotal"]}</td>
                     <td>${Data["cluster"]["tasksTotal"]}</td>
                  </tr>                       
               </tbody>
            </table>                                
         </div>                        
      </div>
   </div>                                   
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- Nimbus configuration. -->
<%def name="tblConfiguration()">
   <div class="col-lg-4">
      <div class="panel panel-default">
         <div class="panel-heading">
            <i class="fa fa-table fa-fw"></i> ${ _('Nimbus Configuration') }
         </div>
         <div class="panel-body">                 
            <table class="table datatables table-striped table-hover table-condensed" id="tblConfiguration" data-tablescroller-disable="true">
               <thead>
                  <tr>
                     <th> ${ _('Key') } </th>
                     <th> ${ _('Value') } </th>                         
                  </tr>
               </thead>
               <tbody>
                  % for row in Data['configuration']:
                     <tr>
                        <td>${row}</td>
                        <td>${Data['configuration'][row]}</td>
                     </tr>   
                  % endfor
               </tbody>
            </table>
         </div>
      </div>
   </div>
</%def>
<!-- ************************************************************************************************************************************* -->                

<!-- Topology Summary. -->
<%def name="tblTopologySummary(paTopology)">
   <div class="col-lg-4">
      <div class="panel panel-default">
         <div class="panel-heading">
            <i class="fa fa-table fa-fw"></i> ${ _('Topology Summary') }
         </div>
         <div class="panel-body">
            <table class="table datatables table-striped table-hover table-condensed" id="tblTopologySummary" data-tablescroller-disable="true">
               <thead>
                  <tr>
                     <th> ${ _('Name') } </th>
                     <th> ${ _('Id.') } </th>
                     <th> ${ _('Status') } </th>
                     <th> ${ _('Uptime') } </th>
                     <th> ${ _('Num.Workers') } </th>
                     <th> ${ _('Num.Executors') } </th>
                     <th> ${ _('Num.Tasks') } </th>
                  </tr>
               </thead>
               <tbody>
                  <tr>
                     <td>${paTopology['name']}</td>
                     <td>${paTopology['id']}</td>                                                        
                     <td>
                        % if paTopology['status'] == "ACTIVE":
                           <span class="label label-success"> ${paTopology['status']} </span>
                        % else:
                           <span class="label label-warning"> ${paTopology['status']} </span>
                        % endif
                     </td>
                     <td>${paTopology['uptime']}</td>
                     <td>${paTopology['workers']}</td>
                     <td>${paTopology['executors']}</td>
                     <td>${paTopology['tasks']}</td>
                  </tr>                       
               </tbody>
            </table>
         </div>
      </div>
   </div>   
</%def>
<!-- ************************************************************************************************************************************* -->                                

<!-- New Window Modal. Rebalance Topology -->
<%def name="tblRebalanceTopology(paTopology)">
   <div class="modal hide fade" id="tblRebalanceTopology" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
         <form id="frmRebalanceTopology" method="post">
            <div class="modal-content">
               <div class="modal-header">
                  <h3> ${ _('Custom Rebalance:') } <b>${paTopology['name']}</b></h3>
               </div>
               <div class="modal-body controls">               
                  <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="6">
                     <tr>
                        <td width="25%">
                           <label>${ _('Set Workers') }</label><input type="number" id="iNumWorkers" min="1" value=1 style="width: 75%"/>                     
                        </td>
                        <td width="25%">
                           <label>${ _('Set Wait Secs.') }</label><input type="number" id="iWaitSecs" min="30" value=30 style="width: 75%"/>                     
                        </td>
                        <td width="25%">
                           <label>${ _('Topology Workers') }</label><input type="number" name="numTopologyWorkers" min="0" value="${paTopology['workers']}" disabled style="width: 75%"/>
                        </td>
                        <td width="25%">
                           <label>${ _('Topology Executors') }</label><input type="number" name="numTopologyExecutors" min="0" value="${paTopology['executors']}" disabled style="width: 75%"/>
                        </td>
                     </tr>
                     <tr valign="top">
                        <td colspan="4">
                           <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="6">
                              <tr valign="top">
                                 <td width="50%">
                                    <div class="col-lg-4">
                                       <div class="panel panel-default">
                                          <div class="panel-heading">
                                             <i class="fa fa-table fa-fw"></i> ${ _('Spouts') }
                                          </div>
                                          <div class="panel-body">
                                             % for row in Data['spouts']:
                                                <input type="checkbox" name="cp_${row['spoutId']}" id="cp_${row['spoutId']}"/>${row["spoutId"]} 
                                                <input type="number" id="numExecutors_${row['spoutId']}" min="0" placeholder="${ _('Set Num. Executors') }" style="width: 96%"/>                                       
                                             % endfor
                                          </div>
                                       </div>
                                    </div>
                                 </td>      
                                 <td width="50%">
                                    <div class="col-lg-4">
                                       <div class="panel panel-default">
                                          <div class="panel-heading">
                                             <i class="fa fa-table fa-fw"></i> ${ _('Bolts') }
                                          </div>
                                          <div class="panel-body">
                                             % for row in Data['bolts']:
                                                <input type="checkbox" name="cp_${row['boltId']}" id="cp_${row['boltId']}"/>${row["boltId"]} 
                                                <input type="number" id="numExecutors_${row['boltId']}" min="0" placeholder="${ _('Set Num. Executors') }" style="width: 96%"/>                                       
                                             % endfor
                                          </div>
                                       </div>
                                    </div>                            
                                 </td>
                              </tr>
                           </table>   
                        </td>   
                     </tr>                                    
                  </table>               
               </div>
               <div class="modal-footer">      
                  <div id="divErrorRebalance" class="hide" style="position: absolute; left: 10px;">
                     <span class="label label-important"> ${ _('ERROR rebalancing this topology') } </span>
                  </div>
                  <input type="hidden" id="sAction" value="rebalance">
                  <input type="hidden" id="sNameTopology" value="${paTopology['name']}">
                  <button type="button" id="btnCancel" class="btn btn-default" data-dismiss="modal">${ _('Cancel') }</button>
                  <button type="button" id="btnSubmit" class="btn btn-primary" data-bind="click: set_topology_status">${ _('Submit') }</button>
                  <img id="imgLoading" src="/static/art/spinner.gif" class="hide"/>
               </div>
            </div>   
         </form>      
      </div>
   </div>
</%def>
<!-- ************************************************************************************************************************************* -->   

<!-- New Window Modal. Submit New Topology -->
<%def name="tblSubmitTopology(pfForm1)">
   <div class="modal hide fade" id="tblSubmitTopology" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
         <form id="frmSubmitTopology" method="post" enctype="multipart/form-data" action="/storm/set_topology_status/">
            <div class="modal-content">
               <div class="modal-header">
                  <h3>${ _('Create New Topology') } </b></h3>
               </div>
               <div class="modal-body controls">
                  ${pfForm1.as_p()|n}                  
               </div>
               <div class="modal-footer">      
                  <input type="hidden" name="psAction" value="submitTopology">
                  <input type="hidden" name="psURL" value="${request.get_full_path()}">                  
                  <button type="button" class="btn btn-default" data-dismiss="modal">${ _('Cancel') }</button>                  
                  <input type="submit" class="btn btn-primary" value="${ _('Submit') }"/>            
               </div>
            </div>   
         </form>      
      </div>
   </div>
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- New Window Modal. Save Topology to HDFS -->
<%def name="tblSaveTopology(pfForm1)">
   <div class="modal hide fade" id="tblSaveTopology" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
         <form id="frmSubmitTopology" method="post" enctype="multipart/form-data" action="/storm/set_topology_status/">
            <div class="modal-content">
               <div class="modal-header">
                  <h3>${ _('Save Topology to HDFS') } </b></h3>
               </div>
               <div class="modal-body controls">
                  ${pfForm1.as_p()|n}                  
               </div>
               <div class="modal-footer">      
                  <input type="hidden" name="psAction" value="saveTopology">
                  <input type="hidden" name="psURL" value="${request.get_full_path()}">                  
                  <button type="button" class="btn btn-default" data-dismiss="modal">${ _('Cancel') }</button>                  
                  <input type="submit" class="btn btn-primary" value="${ _('Save') }"/>            
               </div>
            </div>   
         </form>      
      </div>
   </div>
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- New Window Modal. Active Topology -->
<%def name="tblActivate(paTopology)">
   <div class="modal hide fade" id="tblActivate" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">         
            <div class="modal-content">
               <div class="modal-header">
                  <h3>${ _('Confirm action') } </b></h3>
               </div>
               <div class="modal-body controls">
                  ${ _('Are you sure you want to do this action: ACTIVE? ') }
               </div>
               <div class="modal-footer">      
                  <button type="button" class="btn btn-default" data-dismiss="modal">${ _('No') }</button>                  
                  <button type="button" class="btn btn-primary" onclick="changeTopologyStatus('${paTopology['id']}', 'activate', false, 0)">${ _('Yes') }</button>
               </div>
            </div>   
      </div>
   </div>
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- New Window Modal. Inactive Topology -->
<%def name="tblDeactivate(paTopology)">
   <div class="modal hide fade" id="tblDeactivate" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">         
            <div class="modal-content">
               <div class="modal-header">
                  <h3>${ _('Confirm action') } </b></h3>
               </div>
               <div class="modal-body controls">
                  ${ _('Are you sure you want to do this action: Deactivate? ') }
               </div>
               <div class="modal-footer">      
                  <button type="button" class="btn btn-default" data-dismiss="modal">${ _('No') }</button>                  
                  <button type="button" class="btn btn-primary" onclick="changeTopologyStatus('${paTopology['id']}', 'deactivate', false, 0)">${ _('Yes') }</button>
               </div>
            </div>   
      </div>
   </div>
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- New Window Modal. Automatic Rebalance Topology -->
<%def name="tblAutomaticRebalance(paTopology)">
   <div class="modal hide fade" id="tblAutomaticRebalance" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">         
            <div class="modal-content">
               <div class="modal-header">
                  <h3>${ _('Confirm action') } </b></h3>
               </div>
               <div class="modal-body controls">
                  ${ _('Are you sure you want to do this action: REBALANCE? ') }
               </div>
               <div class="modal-footer">      
                  <button type="button" class="btn btn-default" data-dismiss="modal">${ _('No') }</button>                  
                  <button type="button" class="btn btn-primary" onclick="changeTopologyStatus('${paTopology['id']}', 'rebalance', true, 5)">${ _('Yes') }</button>
               </div>
            </div>   
      </div>
   </div>
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- New Window Modal. Kill Topology -->
<%def name="tblKill(paTopology)">
   <div class="modal hide fade" id="tblKill" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">         
            <div class="modal-content">
               <div class="modal-header">
                  <h3>${ _('Confirm action') } </b></h3>
               </div>
               <div class="modal-body controls">
                  ${ _('Are you sure you want to do this action: KILL? ') }
               </div>
               <div class="modal-footer">      
                  <div id="divErrorKill" class="hide" style="position: absolute; left: 10px;">
                     <span class="label label-important"> ${ _('ERROR killing this topology') } </span>
                  </div>
                  <button type="button" class="btn btn-default" data-dismiss="modal">${ _('No') }</button>                  
                  <button type="button" class="btn btn-primary" onclick="changeTopologyStatus('${paTopology['id']}', 'kill', true, 5)">${ _('Yes') }</button>
               </div>
            </div>   
      </div>
   </div>
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- New Window Modal. Show an error -->
<%def name="divERROR(psError)">
   <div id="divERROR" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
      <div class="modal-dialog">
         <div class="modal-content">
            <div class="modal-header">
               <button class="close" data-dismiss="modal" aria-hidden="true">X</button>
               <h3 class="modal-title">${ _('Last error:') }</h3>
            </div>
            ${psError}
         </div>
      </div>   
   </div>
</%def>
<!-- ************************************************************************************************************************************* -->
