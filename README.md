SYSREPORT(1) - General Commands Manual

# NAME

**sysreport** - create system health reports

# SYNOPSIS

**sysreport**
\[**-hsV**]

# DESCRIPTION

**sysreport**
executes plugins in
`PLUGIN_PATH`
and generates a system health report from their output and exit codes.
**sysreport**
output can be used as input for
sysview(1)
to generate a static html monitoring dashboard.

The options are as follows:

**-h**

> Print usage.

**-V**

> Print version.

**-s**

> Silent flag. Only generates a report if any plugin's exit code is not zero.
> This can be useful to configure alerting.

# ENVIRONMENT

`SR_PLUGIN_PATH`

> The plugin path
> **sysreport**
> uses. Defaults to "/usr/local/share/sysreport/plugins".

# EXAMPLES

Add or update a host's
**sysreport**
on a remote
web server's
sysview(1)
dashboard:

	$ sysreport | ssh www sysview /var/www/htdocs/sysview

Alerting can be achieved by configuring a cron job that executes
**sysreport**
with the silent flag and pipes it's output into the
mail(1)
command using the -E option to prevent sending empty messages.

	0 * * * * -s /usr/local/bin/sysreport -s | mail -E -s sysreport alerts@example.org

# SEE ALSO

sysview(1)

REPORTIFY(1) - General Commands Manual

# NAME

**reportify** - reportifies a given command

# SYNOPSIS

**reportify**
\[**-hsV**]
**-t**&nbsp;*type*
**-c**&nbsp;*command*

# DESCRIPTION

**reportify**
executes a given command and prints a
sysreport(1)
compliant report to stdout.
**reportify**
output can be used as input for
sysview(1)
to generate or update a static html monitoring dashboard.

The options are as follows:

**-c** *command*

> Command to execute.

**-h**

> Print usage.

**-V**

> Print version.

**-s**

> Silent flag. Omit
> *command*
> stdout from report if exit code is zero.

**-t** *type*

> Value for the "Type:" field in the generated report.

# EXAMPLES

Execute a backup script and report the status back to
sysview(1).
Also reduce the size required in the
sysview(1)
dashboard by omitting the backup script's stdout on success:

	$ reportify -s -t backup -c "backup.sh" | ssh www sysview /var/www/htdocs/sysview

# SEE ALSO

sysreport(1)

