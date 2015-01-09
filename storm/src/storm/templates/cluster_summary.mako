<%!from desktop.views import commonheader, commonfooter %>

${commonheader("Cluster Summary", app_name, user) | n,unicode}

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
    ["Storm Dashboard", url('storm:storm_dashboard')],    
    ["Cluster Summary", url('storm:cluster_summary')]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Cluster Summary')}

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
