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

${commonheader("Components Explain", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />

## Use double hashes for a mako template comment
## Main body

<link href="/storm/static/css/storm.css" rel="stylesheet">

${ JavaScript.import_js() }

<script type="text/javascript" charset="utf-8">                     
   $(document).ready(function() {                                                                 
      $('#tblTopologyComponent').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	      "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>",
         "oLanguage":{
              "sLengthMenu":"${_('Show _MENU_ entries')}",
              "sSearch":"${_('Search')}",
              "sEmptyTable":"${_('No data available')}",
              "sInfo":"${_('Showing _START_ to _END_ of _TOTAL_ entries')}",
              "sInfoEmpty":"${_('Showing 0 to 0 of 0 entries')}",
              "sInfoFiltered":"${_('(filtered from _MAX_ total entries)')}",
              "sZeroRecords":"${_('No matching records')}",
              "oPaginate":{
                  "sFirst":"${_('First')}",
                  "sLast":"${_('Last')}",
                  "sNext":"${_('Next')}",
                  "sPrevious":"${_('Previous')}"
              }
        }        
	    } );
	    
      $('#tblTopologyStats').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	      "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>",
         "oLanguage":{
              "sLengthMenu":"${_('Show _MENU_ entries')}",
              "sSearch":"${_('Search')}",
              "sEmptyTable":"${_('No data available')}",
              "sInfo":"${_('Showing _START_ to _END_ of _TOTAL_ entries')}",
              "sInfoEmpty":"${_('Showing 0 to 0 of 0 entries')}",
              "sInfoFiltered":"${_('(filtered from _MAX_ total entries)')}",
              "sZeroRecords":"${_('No matching records')}",
              "oPaginate":{
                  "sFirst":"${_('First')}",
                  "sLast":"${_('Last')}",
                  "sNext":"${_('Next')}",
                  "sPrevious":"${_('Previous')}"
              }
        }
	    } );
	    
      $('#tblTopologyInput').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	      "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>",
         "oLanguage":{
              "sLengthMenu":"${_('Show _MENU_ entries')}",
              "sSearch":"${_('Search')}",
              "sEmptyTable":"${_('No data available')}",
              "sInfo":"${_('Showing _START_ to _END_ of _TOTAL_ entries')}",
              "sInfoEmpty":"${_('Showing 0 to 0 of 0 entries')}",
              "sInfoFiltered":"${_('(filtered from _MAX_ total entries)')}",
              "sZeroRecords":"${_('No matching records')}",
              "oPaginate":{
                  "sFirst":"${_('First')}",
                  "sLast":"${_('Last')}",
                  "sNext":"${_('Next')}",
                  "sPrevious":"${_('Previous')}"
              }
        }
	    } );

      $('#tblTopologyOutput').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	      "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>",
         "oLanguage":{
              "sLengthMenu":"${_('Show _MENU_ entries')}",
              "sSearch":"${_('Search')}",
              "sEmptyTable":"${_('No data available')}",
              "sInfo":"${_('Showing _START_ to _END_ of _TOTAL_ entries')}",
              "sInfoEmpty":"${_('Showing 0 to 0 of 0 entries')}",
              "sInfoFiltered":"${_('(filtered from _MAX_ total entries)')}",
              "sZeroRecords":"${_('No matching records')}",
              "oPaginate":{
                  "sFirst":"${_('First')}",
                  "sLast":"${_('Last')}",
                  "sNext":"${_('Next')}",
                  "sPrevious":"${_('Previous')}"
              }
        }
	    } );

      $('#tblTopologyExecutors').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>",
           "oLanguage":{
              "sLengthMenu":"${_('Show _MENU_ entries')}",
              "sSearch":"${_('Search')}",
              "sEmptyTable":"${_('No data available')}",
              "sInfo":"${_('Showing _START_ to _END_ of _TOTAL_ entries')}",
              "sInfoEmpty":"${_('Showing 0 to 0 of 0 entries')}",
              "sInfoFiltered":"${_('(filtered from _MAX_ total entries)')}",
              "sZeroRecords":"${_('No matching records')}",
              "oPaginate":{
                  "sFirst":"${_('First')}",
                  "sLast":"${_('Last')}",
                  "sNext":"${_('Next')}",
                  "sPrevious":"${_('Previous')}"
              }
        }        
	    } );
	    
      $('#tblTopologyErrors').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>",
           "oLanguage":{
              "sLengthMenu":"${_('Show _MENU_ entries')}",
              "sSearch":"${_('Search')}",
              "sEmptyTable":"${_('No data available')}",
              "sInfo":"${_('Showing _START_ to _END_ of _TOTAL_ entries')}",
              "sInfoEmpty":"${_('Showing 0 to 0 of 0 entries')}",
              "sInfoFiltered":"${_('(filtered from _MAX_ total entries)')}",
              "sZeroRecords":"${_('No matching records')}",
              "oPaginate":{
                  "sFirst":"${_('First')}",
                  "sLast":"${_('Last')}",
                  "sNext":"${_('Next')}",
                  "sPrevious":"${_('Previous')}"
              }
        }        
	    } );
   });      
</script>

${ storm.menubar(section = 'Components Explain')}

% if Data['error'] == 1:
  <div class="container-fluid">
    <div class="card">
      <div class="card-body">
        <div class="alert alert-error">
          <h2>${ _('Error connecting to the Storm UI server:') } <b>${Data['storm_ui']}</b></h2>
          <h3>${ _('Please contact your administrator to solve this.') }</h3>
        </div>
      </div>
    </div>
  </div>  
% else:
  <%
     _breadcrumbs = [
       [_('Storm Dashboard'), url('storm:storm_dashboard')],    
       [_('Topology ') + Data['topology']['id'] + _(' Detail'), url('storm:detail_dashboard', topology_id = Data['topology']['id'], system_id = 0)],
       [Data['components']['componentType'] + " Id. " + Data['component_id'] + _(' Explain'), url('storm:components', topology_id = Data['topology']['id'], component_id = Data['component_id'], system_id = 0)]
     ]
  %>

  ${ storm.header(_breadcrumbs) }

  <div id="divPrincipal" class="container-fluid">
    <div class="card">        
      <div class="card-body">
         <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
            <tr>
               <td colspan="2">
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-table fa-fw"></i> ${ _('Component Summary') }
                        </div>
                        <div class="panel-body">
                           <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyComponent" data-tablescroller-disable="true">
                              <thead>
                                 <tr>
                                    <th> ${ _('Id.') } </th>
                                    <th> ${ _('Topology') } </th>
                                    <th> ${ _('Executors') } </th>
                                    <th> ${ _('Tasks') } </th>                         
                                 </tr>
                              </thead>
                              <tbody>
                                 <tr>                         
                                    <td>${Data['component_id']}</td>
                                    <td>${Data['components']['name']}</td>                                                        
                                    <td>${Data['components']['executors']}</td>
                                    <td>${Data['components']['tasks']}</td>                                                 
                                 </tr>                      
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>   
               </td>
            </tr>
            <tr>
               % if Data['components']['componentType'] == "bolt":
               <td colspan="2">                
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-table fa-fw"></i> ${Data['components']['componentType']} ${ _('Stats') }
                        </div>
                        <div class="panel-body">
                           <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyStats" data-tablescroller-disable="true">
                              <thead>
                                 <tr>
                                    <th> ${ _('Window') } </th>
                                    <th> ${ _('Emitted') } </th>
                                    <th> ${ _('Transferred') } </th>
                                    <th> ${ _('Execute Latency (ms)') } </th>
                                    <th> ${ _('Executed') } </th>
                                    <th> ${ _('Process Latency (ms)') } </th>
                                    <th> ${ _('Acked') } </th>
                                    <th> ${ _('Failed') } </th>                         
                                 </tr>
                              </thead>
                              <tbody>
                                 % for row in Data['components']["boltStats"]:
                                    <tr>                         
                                       <td>${row["windowPretty"]}</td>
                                       <td>${row["emitted"]}</td>                                                        
                                       <td>${row["transferred"]}</td>
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
                                    </tr>                      
                                 % endfor   
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>   
               </td>
               % else:
               <td colspan="2">                  
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-table fa-fw"></i> ${Data['components']['componentType']} ${ _('Stats') }
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
                                 % for row in Data['components']["spoutSummary"]:
                                    <tr>                         
                                       <td>${row["windowPretty"]}</td>
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
                                          </span>
                                       </td>                         
                                    </tr>                      
                                 % endfor   
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>   
               </td>
               % endif
            </tr>
            <tr>
               <td colspan="2">
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-table fa-fw"></i> ${ _('Input Stats') }
                        </div>
                        <div class="panel-body">               
                           <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyInput" data-tablescroller-disable="true">
                              <thead>
                                 <tr>
                                    <th> ${ _('Component') } </th>
                                    <th> ${ _('Stream') } </th>
                                    <th> ${ _('Execute Latency (ms)') } </th>
                                    <th> ${ _('Executed') } </th>
                                    <th> ${ _('Process Latency (ms)') } </th>
                                    <th> ${ _('Acked') } </th>
                                    <th> ${ _('Failed') } </th>                         
                                 </tr>
                              </thead>
                              <tbody>
                                 % for row in Data['input']:
                                    <tr>                         
                                       <td>${row["component"]}</td>
                                       <td>${row["stream"]}</td>                                                        
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
               <td colspan="2">
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-table fa-fw"></i> ${ _('Output Stats') }
                        </div>
                        <div class="panel-body">                
                           <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyOutput" data-tablescroller-disable="true">
                              <thead>
                                 <tr>
                                    <th> ${ _('Stream') } </th>
                                    <th> ${ _('Emitted') } </th>
                                    <th> ${ _('Transferred') } </th>                                   
                                 </tr>
                              </thead>
                              <tbody>
                                 % for row in Data['output']:
                                    <tr>                         
                                       <td>${row["stream"]}</td>
                                       <td>${row["emitted"]}</td>
                                       <td>${row["transferred"]}</td>
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
               % if Data['components']['componentType'] == "bolt":
               <td colspan="2">
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-table fa-fw"></i> ${ _('Executors') }
                        </div>
                        <div class="panel-body">                 
                           <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyExecutors" data-tablescroller-disable="true">
                              <thead>
                                 <tr>
                                    <th> ${ _('Id.') } </th>
                                    <th> ${ _('Uptime') } </th>
                                    <th> ${ _('Host') } </th>
                                    <th> ${ _('Port') } </th>
                                    <th> ${ _('Emitted') } </th>
                                    <th> ${ _('Transferred') } </th>
                                    <th> ${ _('Capacity (last 10m)') } </th>
                                    <th> ${ _('Execute Latency (ms)') } </th>
                                    <th> ${ _('Executed') } </th>
                                    <th> ${ _('Process Latency (ms)') } </th>
                                    <th> ${ _('Acked') } </th>
                                    <th> ${ _('Failed') } </th>              
                                 </tr>
                              </thead>
                              <tbody>
                                 % for row in Data['executor']:
                                    <tr>                         
                                       <td>${row["id"]}</td>
                                       <td>${row["uptime"]}</td>                                                        
                                       <td>${row["host"]}</td>
                                       <td>
                                          <a href="${Data['log_url']}${row["port"]}.log">
                                             ${row["port"]}
                                          </a>   
                                       </td>
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
                                    </tr>                      
                                 % endfor   
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>   
               </td>
               % else:
               <td colspan="2">
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-table fa-fw"></i> ${ _('Executors') }
                        </div>
                        <div class="panel-body">                
                           <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyExecutors" data-tablescroller-disable="true">
                              <thead>
                                 <tr>
                                    <th> ${ _('Id.') } </th>
                                    <th> ${ _('Uptime') } </th>
                                    <th> ${ _('Host') } </th>
                                    <th> ${ _('Port') } </th>
                                    <th> ${ _('Emitted') } </th>
                                    <th> ${ _('Transferred') } </th>                         
                                    <th> ${ _('Complete Latency (ms)') } </th>
                                    <th> ${ _('Acked') } </th>
                                    <th> ${ _('Failed') } </th>              
                                 </tr>
                              </thead>
                              <tbody>
                                 % for row in Data['executor']:
                                    <tr>                         
                                       <td>${row["id"]}</td>
                                       <td>${row["uptime"]}</td>                                                        
                                       <td>${row["host"]}</td>
                                       <td>
                                          <a href="${Data['log_url']}${row["port"]}.log">
                                             ${row["port"]}
                                          </a> 
                                       </td>
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
                                          </span>
                                       </td>
                                    </tr>                      
                                 % endfor   
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>   
               </td>
               % endif
            </tr>
            <tr>
               <td colspan="2">
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-table fa-fw"></i> ${ _('Errors') }
                        </div>
                        <div class="panel-body">                 
                           <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyErrors" data-tablescroller-disable="true">
                              <thead>
                                 <tr>
                                    <th> ${ _('Time') } </th>
                                    <th> ${ _('Error') } </th>                         
                                 </tr>
                              </thead>
                              <tbody>
                                 % for row in Data['errors']:
                                    <tr>                         
                                       <td>${row["time"]}</td>
                                       <td>
                                          <span style="color: green; font-weight: bold">
                                             ${row["error"]}
                                          </span>
                                       </td>                                                                                                        
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
% endif
${commonfooter(messages) | n,unicode}
