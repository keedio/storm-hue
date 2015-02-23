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
%>

${commonheader("Topology Stats Detail", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />

## Use double hashes for a mako template comment
## Main body

<link href="/storm/static/css/storm.css" rel="stylesheet">

${ JavaScript.import_js() }

<script type="text/javascript" charset="utf-8">                     
   $(document).ready(function() { 
      ko.applyBindings(new StormViewModel());     
      
      $('#tblTopologyStats').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
	    
      $('#tblTopologySpouts').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
	    
      $('#tblTopologyBolts').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );    
   });      
</script>

<%
  _breadcrumbs = [
    [_('Storm Dashboard'), url('storm:storm_dashboard')],    
    [_('Topology ') + Topology[0] + _(' Detail'), url('storm:detail_dashboard', topology_id = Topology[0], system_id = 0)],
    [_('Topology ') + Topology[0] + _(' Stats Detail'), url('storm:topology', topology_id = Topology[0], window_id = Stats['window'])]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Topology Stats Detail')}

<div id="divPrincipal" class="container-fluid">
  <div class="card">        
    <div class="card-body">
       <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">                                          
          ${Templates.ControlPanelTopology("topology")}
          <tr>
             <td colspan="3">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-table fa-fw"></i> ${ _('Window Summary') }
                      </div>
                      <div class="panel-body">                
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyStats" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> ${ _('Window') } </th>
                                  <th> ${ _('Emitted') } </th>
                                  <th> ${ _('Transferred') } </th>
                                  <th> ${ _('Complete Latency (ms)') } </th>
                                  <th> ${ _('Acked') } </th>
                                  <th> ${ _('Failed') } </th>                         
                               </tr>
                            </thead>
                            <tbody>
                               <tr>                         
                                  <td>
                                     <a class="fa fa-tachometer" title="${ _('Topology Stats Dashboard') }" href="${url('storm:topology_dashboard', topology_id = Topology[0], window_id = Stats['window'])}"></a>
                                     <a href="${url('storm:topology', topology_id = Topology[0], window_id = Stats['window'])}"> ${Stats["windowPretty"]} </a>
                                  </td>
                                  <td>${Stats["emitted"]}</td>                                                        
                                  <td>${Stats["transferred"]}</td>
                                  <td>${Stats["completeLatency"]}</td>
                                  <td>
                                     <span style="color: green; font-weight: bold">
                                        ${Stats["acked"]}
                                     </span>
                                  </td>
                                  <td>
                                     <span style="color: red; font-weight: bold">
                                        ${Stats["failed"]}
                                     </span>
                                  </td>                         
                               </tr>                      
                            </tbody>
                         </table>
                      </div>
                   </div>
                </div>   
             </td>
          </tr>
          <tr>
             <td colspan="3">                      
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-table fa-fw"></i> ${ _('Spouts') } (${Stats["windowPretty"]})
                      </div>
                      <div class="panel-body">
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologySpouts" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> ${ _('Id.') } </th>
                                  <th> ${ _('Executors') } </th>
                                  <th> ${ _('Tasks') } </th>
                                  <th> ${ _('Emitted') } </th>
                                  <th> ${ _('Transferred') } </th>
                                  <th> ${ _('Complete Latency (ms)') } </th>                         
                                  <th> ${ _('Acked') } </th>
                                  <th> ${ _('Failed') } </th>
                                  <th> ${ _('Last Error') } </th>
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Spouts:
                                  <tr>
                                     <td>${row["spoutId"]}</td>
                                     <td>${row["executors"]}</td>                                                        
                                     <td>${row["tasks"]}</td>
                                     <td>${row["emitted"]}</td>
                                     <td>${row["transferred"]}</td>
                                     <td>${row["completeLatency"]}</td>
                                     <td>
                                        <span style="color: green; font-weight: bold">
                                           ${row["acked"]}
                                        </span>
                                     </td>
                                     <td>
                                        <span style="color: red; font-weight: bold">
                                           ${row["failed"]}
                                        </span></td>
                                     <%
                                        sLastError = row["lastError"][0:25]
                                     %>
                                     <td title="${row["lastError"]}">${sLastError}</td>
                                  </tr>
                               % endfor
                            </tbody>
                         </table>
                      </div>
                   </div>
                </div>   
             </td>
          </tr>
          <tr>
             <td colspan="3">               
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-table fa-fw"></i> ${ _('Bolts') } (${Stats["windowPretty"]})
                      </div>
                      <div class="panel-body">
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyBolts" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> ${ _('Id.') } </th>
                                  <th> ${ _('Executors') } </th>
                                  <th> ${ _('Tasks') } </th>
                                  <th> ${ _('Emitted') } </th>
                                  <th> ${ _('Transferred') } </th>
                                  <th> ${ _('Capacity (last 10m)') } </th>                         
                                  <th> ${ _('Execute latency (ms)') } </th>
                                  <th> ${ _('Executed') } </th>
                                  <th> ${ _('Process latency (ms)') } </th>
                                  <th> ${ _('Acked') } </th>
                                  <th> ${ _('Failed') } </th>
                                  <th> ${ _('Last error') } </th>
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Bolts:
                                  <tr>
                                     <td>${row["boltId"]}</td>
                                     <td>${row["executors"]}</td>                                                        
                                     <td>${row["tasks"]}</td>
                                     <td>${row["emitted"]}</td>
                                     <td>${row["transferred"]}</td>
                                     <td>${row["capacity"]}</td>
                                     <td>${row["executeLatency"]}</td>
                                     <td>${row["executed"]}</td>
                                     <td>${row["processLatency"]}</td>
                                     <td>
                                        <span style="color: green; font-weight: bold">
                                           ${row["acked"]}
                                        </span>
                                     </td>
                                     <td>
                                        <span style="color: red; font-weight: bold">
                                           ${row["failed"]}
                                        </span>
                                     </td>
                                     <td>${row["lastError"]}</td>
                                  </tr>
                               % endfor
                            </tbody>
                         </table>
                      </div>
                   </div>
                </div>   
             </td>
          </tr>
       </table>   
    </div>
  </div>
</div>

${commonfooter(messages) | n,unicode}
