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

${commonheader("Cluster Summary", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />

## Use double hashes for a mako template comment
## Main body

<link href="/storm/static/css/storm.css" rel="stylesheet">

${ JavaScript.import_js() }

<script type='text/javascript'>    
   $(document).ready(function() {                                    
	    $('#tblCluster').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
	    	                                       
	    $('#tblSupervisor').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );   
   });
</script>

<%
  _breadcrumbs = [
    [_('Storm Dashboard'), url('storm:storm_dashboard')],    
    [_('Cluster Summary'), url('storm:cluster_summary')]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Cluster Summary')}

${Templates.tblSubmitTopology(frmNewTopology)}
${Templates.tblSaveTopology(frmHDFS)}

<div class="container-fluid">
   <div class="card">        
      <div class="card-body">         
         <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">          
            <tr>               
               <td>
                  ${Templates.tblSupervisor()}
               </td>
            </tr>
            <tr>               
               <td>
                  ${Templates.tblCluster()}
               </td>
            </tr>
         </table>
      </div>
   </div>
</div>

${commonfooter(messages) | n,unicode}
