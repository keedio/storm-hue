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

<%!from desktop.views import commonheader, commonfooter %>

${commonheader("Components Explain", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />

## Use double hashes for a mako template comment
## Main body

<link href="/storm/static/css/storm.css" rel="stylesheet">

<style>
   .dataTables_length {
      width: 50%;
      float: left;
      text-align: left;
      vertical-align:top;
   } 
   .dataTables_filter {
      width: 50%;
      float: right;
      text-align: right;
      vertical-align:top;
   }   
</style>

${ JavaScript.import_js() }

<script type="text/javascript" charset="utf-8">                     
   $(document).ready(function() {                                                                 
      $('#tblTopologyComponent').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
	    
      $('#tblTopologyStats').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
	    
      $('#tblTopologyInput').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );

      $('#tblTopologyOutput').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );

      $('#tblTopologyExecutors').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
	    
      $('#tblTopologyErrors').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
   });      
</script>

<%
  _breadcrumbs = [
    ["Storm Dashboard", url('storm:storm_dashboard')],    
    ["Topology " + Topology[0] + " Detail", url('storm:detail_dashboard', topology_id = Topology[0], system_id = 0)],
    [Component[4] + " Id. " + Component[0] + " Explain", url('storm:components', topology_id = Topology[0], component_id = idComponent, system_id = 0)]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Components Explain')}

<div id="divPrincipal" class="container-fluid">
  <div class="card">        
    <div class="card-body">
       <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
          <tr>
             <td colspan="2">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-table fa-fw"></i> Component Summary
                      </div>
                      <div class="panel-body">
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyComponent" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Id. </th>
                                  <th> Topology </th>
                                  <th> Executors </th>
                                  <th> Tasks </th>                         
                               </tr>
                            </thead>
                            <tbody>
                               <tr>                         
                                  <td>${Component[0]}</td>
                                  <td>${Component[1]}</td>                                                        
                                  <td>${Component[2]}</td>
                                  <td>${Component[3]}</td>                                                 
                               </tr>                      
                            </tbody>
                         </table>
                      </div>
                   </div>
                </div>   
             </td>
          </tr>
          <tr>
             % if iBolt == 1:
             <td colspan="2">                
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-table fa-fw"></i> ${Component[4]} Stats
                      </div>
                      <div class="panel-body">
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyStats" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Window </th>
                                  <th> Emitted </th>
                                  <th> Transferred </th>
                                  <th> Execute Latency (ms) </th>
                                  <th> Executed </th>
                                  <th> Process Latency (ms) </th>
                                  <th> Acked </th>
                                  <th> Failed </th>                         
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Stats:
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
                         <i class="fa fa-table fa-fw"></i> ${Component[4]} Stats
                      </div>
                      <div class="panel-body">
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyStats" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Window </th>
                                  <th> Emitted </th>
                                  <th> Transferred </th>                         
                                  <th> Complete Latency (ms) </th>
                                  <th> Acked </th>
                                  <th> Failed </th>                         
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Stats:
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
                         <i class="fa fa-table fa-fw"></i> Input Stats
                      </div>
                      <div class="panel-body">               
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyInput" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Component </th>
                                  <th> Stream </th>
                                  <th> Execute Latency (ms) </th>
                                  <th> Executed </th>
                                  <th> Process Latency (ms) </th>
                                  <th> Acked </th>
                                  <th> Failed </th>                         
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Input:
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
                         <i class="fa fa-table fa-fw"></i> Output Stats
                      </div>
                      <div class="panel-body">                
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyOutput" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Stream </th>
                                  <th> Emitted </th>
                                  <th> Transferred </th>                                   
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Output:
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
             % if iBolt == 1:
             <td colspan="2">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-table fa-fw"></i> Executors
                      </div>
                      <div class="panel-body">                 
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyExecutors" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Id. </th>
                                  <th> Uptime </th>
                                  <th> Host </th>
                                  <th> Port </th>
                                  <th> Emitted </th>
                                  <th> Transferred </th>
                                  <th> Capacity (last 10m) </th>
                                  <th> Execute Latency (ms) </th>
                                  <th> Executed </th>
                                  <th> Process Latency (ms) </th>
                                  <th> Acked </th>
                                  <th> Failed </th>              
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Executors:
                                  <tr>                         
                                     <td>${row["id"]}</td>
                                     <td>${row["uptime"]}</td>                                                        
                                     <td>${row["host"]}</td>
                                     <td>
                                        <a href="${Server_Log}${row["port"]}.log">
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
                         <i class="fa fa-table fa-fw"></i> Executors
                      </div>
                      <div class="panel-body">                
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyExecutors" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Id. </th>
                                  <th> Uptime </th>
                                  <th> Host </th>
                                  <th> Port </th>
                                  <th> Emitted </th>
                                  <th> Transferred </th>                         
                                  <th> Complete Latency (ms) </th>
                                  <th> Acked </th>
                                  <th> Failed </th>              
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Executors:
                                  <tr>                         
                                     <td>${row["id"]}</td>
                                     <td>${row["uptime"]}</td>                                                        
                                     <td>${row["host"]}</td>
                                     <td>
                                        <a href="${Server_Log}${row["port"]}.log">
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
                         <i class="fa fa-table fa-fw"></i> Errors
                      </div>
                      <div class="panel-body">                 
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyErrors" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Time </th>
                                  <th> Error </th>                         
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Errors:
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

${commonfooter(messages) | n,unicode}
