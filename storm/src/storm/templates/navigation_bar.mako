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
def is_selected(section, matcher):
  if section == matcher:
    return "active"
  else:
    return ""
%>

<%def name="header(breadcrumbs, withBody=True)">  
  <div class="container-fluid">
  <div class="row-fluid">
    <div class="card card-small">
      <h1 class="card-heading simple">
      <div class="btn-group pull-right">                        
         <button id="btnNewTopology" data-target="#tblSubmitTopology" class="btn" data-toggle="modal"><i class="fa fa-arrow-circle-o-up"></i> Submit Topology </button>         
      </div>       
      <!--
      <div class="btn-group pull-right" style="display: inline; align: left">
         <div id="upload-dropdown" class="btn-group" style="vertical-align: middle">
            <a href="#" class="btn dropdown-toggle" title="Create topology" data-toggle="dropdown">
               <i class="fa fa-arrow-circle-o-up"></i> 
               Create topology
               <span class="caret"></span>	
            </a>
            <ul class="dropdown-menu">
               <li><a href="#" data-target="#tblSubmitTopology" class="btn" data-toggle="modal" title="Submit a new topology"><i class="fa fa-plus-circle"></i> Submit</a></li>                     
               <li><a href="#" data-target="#tblSaveTopology" class="btn" data-toggle="modal" title="Save to HDFS"><i class="fa fa-floppy-o"></i> Save to HDFS</a></li>                     
            </ul>
         </div>
      </div>
      -->            
      % for idx, crumb in enumerate(breadcrumbs):
        %if crumb[1] != "":
          <a href="${crumb[1]}">${crumb[0]}</a>
        %else:
          ${crumb[0]}
        %endif

        %if idx < len(breadcrumbs) - 1:
          &gt;
        %endif
      % endfor
      </h1>
      %if withBody:
      <div class="card-body">
        <p>
      %endif
</%def>

<%def name="menubar(section = '')">
  <div class="navbar navbar-inverse navbar-fixed-top nokids">
    <div class="navbar-inner">
      <div class="container-fluid">
        <div class="nav-collapse">
          <ul class="nav">
            <li class="${is_selected(section, 'Storm Dashboard')}">
               <a href="/${app_name}"><img src="/storm/static/art/icon_storm_24.png" />  Dashboard </a>
            </li>
            <li class="${is_selected(section, 'Cluster Summary')}">
               <a href="${url('storm:cluster_summary')}"> Cluster Summary </a>
            </li>            
             <li class="${is_selected(section, 'Nimbus Configuration')}">
               <a href="${url('storm:nimbus_configuration')}"> Nimbus Configuration </a>
            </li>                       
          </ul>
        </div>
      </div>
    </div>
  </div>
</%def>
