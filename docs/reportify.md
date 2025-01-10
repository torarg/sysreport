REPORTIFY(1) - General Commands Manual

## NAME

**reportify** - reportifies a given command

## SYNOPSIS

**reportify**
\[**-hsV**]
**-t**&nbsp;*type*
**-c**&nbsp;*command*

## DESCRIPTION

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

## EXAMPLES

Execute a backup script and report the status back to
sysview(1).
Also reduce the size required in the
sysview(1)
dashboard by omitting the backup script's stdout on success:

	$ reportify -s -t backup -c "backup.sh" | ssh www sysview /var/www/htdocs/sysview

## SEE ALSO

sysreport(1)

