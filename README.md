# sysreport

sysreport creates system health reports and writes them to STDOUT.

I created sysreport as a simple monitoring tool for my personal servers. It
executes a bunch of plugins and generates a report. That's it.


## usage

To generate a full health report:

```
# sysreport
Hostname: fileserver.example.org
Date: Fri Jan  3 11:34:29 CET 2025
---
check_cpu.sh
OK: CPU usage is inside expected range.
---
check_disk.sh
OK: All disk usage values inside expected boundries.
---
check_services.sh
CRITICAL: httpd not running.
```


Use the silent flag to only generate a report if any plugin has a return code
greater than 0:


```
# sysreport -s
Hostname: fileserver.example.org
Date: Fri Jan  3 11:34:40 CET 2025
---
check_services.sh
CRITICAL: httpd not running.
```

## cronjob

When using the silent flag (``-s``) it's easy to configure alerting by
just piping the output into the ``mail`` command:

```
# crontab -l
0 * * * * -s /usr/local/bin/sysreport -s | mail -E -s sysreport sysreport@example.org
```

This cronjob generates a sysreport every hour and if something is deemed 
unhealthy also sends an email to sysreport@example.org.

## plugins

Plugins are losely inspired by the nagios/icinga monitoring plugins, i.e. they
match the return code semantics of those (0=OK, 1=WARN, 2=CRITICAL, 3=UNKNOWN).

Plugins are installed in ``/usr/local/share/sysreport/plugins/``.    
sysreport tries to execute every file in this path and generates its
status report from the gathered output and return codes.

Currently plugins are executed without any arguments to keep things simpler.
So limit values and stuff one might want to configure is currently hardcoded
in the plugins. This may or may not change in the future depending on my
needs.
