Storm-HUE: Apache Storm HUE Application
=======================================

Storm-HUE is a [HUE](http://www.gethue.com) application to admin and manage a pool of [Apache Storm](http://storm.apache.org/) topologies. 

Requirements
------------
- [HUE 3.5.0](http://www.gethue.com) or higher

Main Stack
----------
   * Python 
   * Django 
   * Mako
   * jQuery
   * Knockout.js
   * Bootstrap

Installation
------------
To get the Storm-HUE app integrated and running in your HUE deployment:

    $ git clone http://github.com/jjmleiro/storm-hue.git
    $ mv storm-hue/storm $HUE_HOME/apps
    $ cd $HUE_HOME/apps
    $ sudo ../tools/app_reg/app_reg.py --install storm --relative-paths

Modify the hue.ini config file as follows and restart HUE. 

HUE.ini Config section
----------------------
Configs needed in hue.ini config file.

    [storm]
        # The url of the Storm UI
        url=http://storm_server:8080/

        # The URL of the STORM REST service
        # e.g. localhost:8080
        storm_server=localhost
        storm_ui=http://localhost:8080/api/v1
        storm_ui_log=http://localhost:8000/log?file=worker-
        storm_ui_cluster=/cluster/summary
        storm_ui_supervisor=supervisor/summary
        storm_ui_topologies=/topology/summary
        storm_ui_topology=/topology/
        storm_ui_configuration=/cluster/configuration

License
-------
Apache License, Version 2.0
http://www.apache.org/licenses/LICENSE-2.0

--
Jose Juan Martínez <jjmartinez@keedio.com>

