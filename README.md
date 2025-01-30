# rsync_snapshots

Create snapshots using rsync.

## Overview

This Perl script creates snapshots of directories using rsync. It allows you to backup and version control directory contents over time. It can be run manually or via Cron.

### Features

- Creates dated snapshots of source directories
- Supports local and remote sources
- Configurable retention policy for old snapshots  
- Exclusion options for files/directories
- Dry run mode for testing
- Logging capabilities

## Requirements
- [Rsync](https://github.com/RsyncProject/rsync)
- [Perl](https://www.perl.org/) (version 5.12 or higher)

## Usage

```bash
rsync_snapshots [-options]
```

### Options

- `--help`: Print help message
- `--version`: Print version and exit
- `--verbose`: Be more verbose
- `--quiet`: Be quiet (about errors)
- `--no-execute`: Don't actually copy files, just pretend
- `--cron`: Send output to log file instead of stdout
- `--conf <conf>`: Read config from <conf>. Defaults to `/usr/local/etc/rsync_snapshots.conf`
- `--max-delete <n>`: Delete at most n old snapshots
- `--delete-only`: Only delete old snapshots, don't do rsyncs
- `--errors-to <email>`: Send email of rsync errors to <email>

## Configuration

The script uses a configuration file (default `/usr/local/etc/rsync_snapshots.conf`)

### Configuration File Format
The configuration file uses a function-like syntax: `rsync_snapshot(<source>, <dest>, <expire> [, <option>=<value>...]);`
- The <source> can be a remote path (e.g., 'host:/path-to-dir/dir/') or a local path (/path-to-dir/dir/).
- The <dest> is either an absolute or relative path. If it's relative, it's relative to the <source>.
- The <expire> value determines when to expire files or how long to keep snapshots.
- Options can be added with <option>=<value> syntax.
- Expire values use a time string format. The value represents how long to keep snapshots before expiring them. The format consists of the following parts:

```
ny n years
nM n Months
nw n weeks
nd n days
nh n hours
nm n minutes
ns n seconds

examples:

"1w1d1h"
"8d1h"
"193h"
"11580m"
"694800s"
```
#### Options
Supported options include:

```
exclude=<pat>: Exclude files matching pattern <pat>
exclude_from=<file>: Exclude files matching patterns in <file>
rsync_opts=<opts>: Override default rsync options (default is "-xaSH --numeric-ids --delete")
```

## Installation

1. Save the script as `rsync_snapshots` somewhere in your PATH
2. Make it executable: `chmod +x rsync_snapshots`
3. Create a configuration file (see above)
4. Call the script from a cronjob (see below)

## Example Cron Job

```
0 */2 * * * /usr/local/bin/rsync_snapshots -c /path/to/your/config/file.conf
```
This cron job runs the rsync_snapshots script every 2 hours, using your config file at the path provided. Be sure to select an appropriate interval for snapshots, based on your specific use case.

## Licensing

This project is licensed under the GNU General Public License (GPL). See the [LICENSE](LICENSE) file for details.

## How to Contribute

If you'd like to contribute, please fork this repository and submit a pull request.