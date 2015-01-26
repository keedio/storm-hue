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

${commonheader("Nimbus Configuration", app_name, user) | n,unicode}

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

<script type='text/javascript'>    
   $(document).ready(function() {                                    
	    $('#tblConfiguration').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	    	"bPaginate": false,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
   });
</script>

<%
  _breadcrumbs = [
    ["Storm Dashboard", url('storm:storm_dashboard')],    
    ["Nimbus Configuration", url('storm:nimbus_configuration')]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Nimbus Configuration')}

${Templates.tblSubmitTopology(frmNewTopology)}
${Templates.tblSaveTopology(frmHDFS)}

<div class="container-fluid">
  <div class="card">
    <div class="card-body">
       <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
             <td>                
                ${Templates.tblConfiguration()}                                                
             </td>
          </tr>
       </table>
    </div>
  </div>
</div>

${commonfooter(messages) | n,unicode}
