<%!from desktop.views import commonheader, commonfooter %>

${commonheader("Topology Stats Detail", app_name, user) | n,unicode}

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
    ["Storm Dashboard", url('storm:storm_dashboard')],    
    ["Topology " + Topology[0] + " Detail", url('storm:detail_dashboard', topology_id = Topology[0], system_id = 0)],
    ["Topology " + Topology[0] + " Stats Detail", url('storm:topology', topology_id = Topology[0], window_id = Stats['window'])]
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
                         <i class="fa fa-table fa-fw"></i> Window Summary
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
                               <tr>                         
                                  <td>
                                     <a class="fa fa-tachometer" title="Topology Stats Dashboard" href="${url('storm:topology_dashboard', topology_id = Topology[0], window_id = Stats['window'])}"></a>
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
                         <i class="fa fa-table fa-fw"></i> Spouts (${Stats["windowPretty"]})
                      </div>
                      <div class="panel-body">
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologySpouts" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Id. </th>
                                  <th> Executors </th>
                                  <th> Tasks </th>
                                  <th> Emitted </th>
                                  <th> Transferred </th>
                                  <th> Complete Latency (ms) </th>                         
                                  <th> Acked </th>
                                  <th> Failed </th>
                                  <th> Last Error </th>
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
                         <i class="fa fa-table fa-fw"></i> Bolts (${Stats["windowPretty"]})
                      </div>
                      <div class="panel-body">
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyBolts" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Id. </th>
                                  <th> Executors </th>
                                  <th> Tasks </th>
                                  <th> Emitted </th>
                                  <th> Transferred </th>
                                  <th> Capacity (last 10m) </th>                         
                                  <th> Execute latency (ms) </th>
                                  <th> Executed </th>
                                  <th> Process latency (ms) </th>
                                  <th> Acked </th>
                                  <th> Failed </th>
                                  <th> Last error </th>
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
