<%!from desktop.views import commonheader, commonfooter %>

${commonheader("Supervisor", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />
<%namespace name="graphsHUE" file="common_dashboard.mako" />

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
    ["Supervisor", url('storm:supervisor_summary')]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Supervisor')}

<div class="container-fluid">
  <div class="card">        
    <div class="card-body">
       ${Templates.tblSupervisor()}       
    </div>
  </div>
</div>
                                         
${commonfooter(messages) | n,unicode}
