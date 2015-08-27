Changelog
=========

2.0.0 (27-08-2015)
----------------

Features
********

- Support for HUE 3.8 or higher.

1.3.0 (23-06-2015)
----------------

Features
********

- Export dataTables in JSON, XLS, CSV and PDF formats.

1.2.0 (07-04-2015)
----------------

Bug Handling
************

- Issue #14: App Icon
- Issue #15: Fix dataTables CSS
- Issue #16: Fix compile locales
- Issue #17: In PieChart in bolts_dashboard.mako repeat Executors and Tasks
- Issue #18: Not show "Font Awesome" Icons
- Issue #19: Control error if there isn't conection with Storm UI
- Issue #20: Error when create streams
- Issue #21: Error when access "Failed.mako"
- Issue #22: Unexpected token in components_dashboard
- Issue #23: Error in Custom Rebalance 
- Issue #25: In components_dashboard, columns order
- Issue #26: Incorrect position Dashboard Button
- Issue #27: Permission error

1.1.1 (12-02-2015)
----------------

Bug Handling
************

- Issue #9: csrf_token protection error
- Issue #11: Upgrade Django 1.6

1.1.0 (11-02-2015)
----------------

Bug Handling
************

- Issue #3: hue.ini config parameters
- Issue #4: Conf.py default values
- Issue #5: Settings.py never used variable
- Issue #7: Error assigning host when submit topology


1.0.0 (26-01-2015)
----------------

Features
********

- Replicate Storm-UI functionality under HUE look&feel
- Extra dashboards based on HUE look&feel:
    - Resume of Topologies.
    - Topology.
    - Bolts.
    - Spouts.
- Submit new remote topology using Storm Client (it's a requirement that storm client must be installed at the same machine where HUE is running).
- Custom Rebalance Topology.
