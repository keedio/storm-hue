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
