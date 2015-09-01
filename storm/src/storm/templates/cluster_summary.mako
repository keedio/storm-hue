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

<link href="${ static('storm/css/storm.css') }" rel="stylesheet" >

${ JavaScript.import_js() }

<script type='text/javascript'>    
   $(document).ready(function() {                                    
	    $('#tblCluster').dataTable( {	    
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
	    	                                       
	    $('#tblSupervisor').dataTable( {	    
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

${ storm.menubar(section = 'Cluster Summary')}

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
        [_('Cluster Summary'), url('storm:cluster_summary')]
      ]
  %>
  
  ${Templates.tblSubmitTopology(Data['frmNewTopology'])}
  ${Templates.tblSaveTopology(Data['frmHDFS'])}
  ${ storm.header(_breadcrumbs) }

  <div class="container-fluid">
   <div class="card">        
      <div class="card-body">         
         <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">          
            <tr>               
               <td>
                    % if not Data['cluster']:
                      <div class="alert alert-error">
                        ${ _('There are currently no cluster information to show in Storm UI Server: ') }<b>${Data['storm_ui']}</b>
                        </br>
                        ${ _('Please contact your administrator to solve this.') }
                      </div>
                    % else:
                      ${Templates.tblCluster()}
                    % endif  
               </td>
            </tr>
            <tr>               
               <td>
                  % if not Data['supervisor']['supervisors']:
                    <div class="alert alert-error">
                      ${ _('There are currently no supervisor information to show in Storm UI Server: ') }<b>${Data['storm_ui']}</b>
                      </br>
                      ${ _('Please contact your administrator to solve this.') }
                    </div>  
                  % else:
                    ${Templates.tblSupervisor()}
                  % endif              
               </td>
            </tr>
         </table>
      </div>
   </div>
  </div>
% endif

${commonfooter(messages) | n,unicode}
