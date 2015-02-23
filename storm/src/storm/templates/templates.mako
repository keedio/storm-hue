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
            ${ _('No active topologies available') }
         </div>
      </div>
   </div> 
</%def>
<!-- ************************************************************************************************************************************* -->

<!-- Control Panel Topology. Control buttons of a topology. Direct access to dashboards. -->
<%def name="ControlPanelTopology(sURL)">
   <tr>                          
      <td align="left">                               
         <span class="btn-group">            
            % if Topology[2] == "INACTIVE":
               <button id="btnActivate" class="btn" onclick="changeTopologyStatus('${Topology[0]}', 'activate', false, 0)" ><i class="fa fa-play"></i> ${ _('Activate') } </button>                                            
            % else:
               <button id="btnDeactivate" class="btn" onclick="changeTopologyStatus('${Topology[0]}', 'deactivate', false, 0)"><i class="fa fa-stop"></i> ${ _('Deactivate') } </button>
            % endif            
            <div class="btn-toolbar" style="display: inline; vertical-align: middle">
               <div id="upload-dropdown" class="btn-group" style="vertical-align: middle">
                  <a href="#" class="btn upload-link dropdown-toggle" title="${ _('Rebalance') }" data-toggle="dropdown">
                     <i class="fa fa-refresh"></i> ${ _('Rebalance') }
                     <span class="caret"></span>
                  </a>
                  <ul class="dropdown-menu">
                     <li><a href="#" onclick="changeTopologyStatus('${Topology[0]}', 'rebalance', true, 5)" class="btn" title="${ _('Automatic') }"><i class="fa fa-refresh"></i> ${ _('Automatic') } </a></li>                     
                     <li><a href="#" data-target="#tblRebalanceTopology" class="btn" data-toggle="modal" ><i class="fa fa-cog"></i> ${ _('Custom') } </a></li>                     
                  </ul>
               </div>
            </div> 
            <button id="btnKill" class="btn" onclick="changeTopologyStatus('${Topology[0]}', 'kill', true, 5)"><i class="fa fa-trash-o"></i> ${ _('Kill') } </button>            
         </span>  
      </td>
      <td align="right">      
         <span class="btn-group">            
            % if (sURL == "detail_dashboard"):
               % if ShowSystem == 0:
                  <a href="${url('storm:detail_dashboard', topology_id = Topology[0], system_id = ShowSystem)}" class="btn" title="${ _('Hide System Stats') }"><i class="fa fa-check-square-o"></i> ${ _('Hide System Stats') } </a>                   
               % else:
                  <a href="${url('storm:detail_dashboard', topology_id = Topology[0], system_id = ShowSystem)}" class="btn" title="${ _('Show System Stats') }"><i class="fa fa-square-o"></i> ${ _('Show System Stats') } </a>                   
               % endif
            
               <button id="btnTables" class="btn" onclick="changeDisplay('divTables', 'divDashboard')"><i class="fa fa-table"></i> ${ _('Tables') } </button>
            % endif                                                                      
            
            % if (sURL == "components"):
               % if ShowSystem == 0:
                  <a href="${url('storm:components', topology_id = Topology[0], component_id = idComponent, system_id = ShowSystem)}" class="btn" title="${ _('Hide System Stats') }"><i class="fa fa-check-square-o"></i> ${ _('Hide System Stats') } </a>                   
               % else:
                  <a href="${url('storm:components_dashboard', topology_id = Topology[0], component_id = idComponent, system_id = ShowSystem)}" class="btn" title="${ _('Show System Stats') }"><i class="fa fa-square-o"></i> ${ _('Show System Stats') } </a>                   
               % endif
            % endif
            
            <div class="btn-toolbar" style="display: inline; vertical-align: middle">
               <div id="upload-dropdown" class="btn-group" style="vertical-align: middle">
                  <a href="#" class="btn upload-link dropdown-toggle" title="${ _('Dashboard') }" data-toggle="dropdown">
                     <i class="fa fa-tachometer"></i> ${ _('Dashboard') }
                     <span class="caret"></span>
                  </a>
                  <ul class="dropdown-menu">
                     <li><a href="${url('storm:detail_dashboard', topology_id = Topology[0], system_id = 0)}" class="btn" title="${ _('Detail') }"><i class="fa fa-tachometer"></i> ${ _('Detail') } </a></li>
                     <li><a href="${url('storm:spouts_dashboard', topology_id = Topology[0])}" class="btn" title="${ _('Spouts') }"><i class="fa fa-tachometer"></i> ${ _('Spouts') } </a></li>
                     <li><a href="${url('storm:bolts_dashboard', topology_id = Topology[0])}" class="btn" title="${ _('Bolts') }"><i class="fa fa-tachometer"></i> ${ _('Bolts') } </a></li>
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
                  % for row in Supervisor:
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
                     <td>${Cluster["stormVersion"]}</td>
                     <td>${Cluster["nimbusUptime"]}</td>
                     <td>${Cluster["supervisors"]}</td>
                     <td>${Cluster["slotsUsed"]}</td>
                     <td>${Cluster["slotsFree"]}</td>
                     <td>${Cluster["slotsTotal"]}</td>
                     <td>${Cluster["executorsTotal"]}</td>
                     <td>${Cluster["tasksTotal"]}</td>
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
                  % for row in Conf:
                     <tr>
                        <td>${row["key"]}</td>
                        <td>${row["value"]}</td>                                                                                    
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
<%def name="tblTopologySummary()">
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
                     <td>${Topology[1]}</td>
                     <td>${Topology[0]}</td>                                                        
                     <td>
                        % if Topology[2] == "ACTIVE":
                           <span class="label label-success"> ${Topology[2]} </span>
                        % else:
                           <span class="label label-warning"> ${Topology[2]} </span>
                        % endif
                     </td>
                     <td>${Topology[3]}</td>
                     <td>${Topology[4]}</td>
                     <td>${Topology[5]}</td>
                     <td>${Topology[6]}</td>
                  </tr>                       
               </tbody>
            </table>
         </div>
      </div>
   </div>   
</%def>
<!-- ************************************************************************************************************************************* -->                                

<!-- New Window Modal. Rebalance Topology -->
<%def name="tblRebalanceTopology(psName)">
   <div class="modal hide fade" id="tblRebalanceTopology" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
         <form id="frmRebalanceTopology" method="post">
            <div class="modal-content">
               <div class="modal-header">
                  <h3> ${ _('Custom Rebalance:') } <b>${psName}</b></h3>
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
                           <label>${ _('Topology Workers') }</label><input type="number" name="numTopologyWorkers" min="0" value="${Topology[4]}" disabled style="width: 75%"/>
                        </td>
                        <td width="25%">
                           <label>${ _('Topology Executors') }</label><input type="number" name="numTopologyExecutors" min="0" value="${Topology[5]}" disabled style="width: 75%"/>
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
                                             % for row in Spouts:
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
                                             % for row in Bolts:
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
                  <div id="divError" class="hide" style="position: absolute; left: 10px;">
                     <span class="label label-important"> ${ _('ERROR rebalancing this topology') } </span>
                  </div>
                  <input type="hidden" id="sAction" value="rebalance">
                  <input type="hidden" id="sNameTopology" value="${psName}">
                  <button type="button" class="btn btn-default" data-dismiss="modal">${ _('Cancel') }</button>                                    
                  <button type="button" class="btn btn-primary" data-bind="click: set_topology_status">${ _('Submit') }</button>
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
