---
title: FAQ
layout: default
---

Anything that isn't covered here may be found on the <a
href="extra_tips.html">Extra Tips</a> page.

* TOC
{:toc}

### What is your release cycle?

It varies, averaging once or twice a year. If bugs are found and
reported, a release will happen sooner depending on the severity.
Upcoming releases can be tracked using the [Milestones
page](https://github.com/theimpossibleastronaut/rmw/milestones). The
dates may change but Andy tries to keep them as up-to-date as
possible.

### Can rmw replace rm? Can I alias rmw to rm?

I don't recommend it. Many other utilities use rm in the background and
you'd wind up with a very full trash can. Also, rmw doesn't have the
same command line options as rm (see also: an <a
href="https://github.com/theimpossibleastronaut/rmw/discussions/305">extended
discussion</a>)

### How do I know if rmw is compatible with my Desktop trash?

When rmw moves a file to a waste or trash directory, it also writes a
*.trashinfo* file to the corresponding trash directory. The default
waste directory that rmw uses is *~/.local/share/Waste*, therefore
<code class="w3-codespan">rmw foo</code> would result in

<p class="w3-code">
  ~/.local/share/Waste/files/foo<br />
  ~/.local/share/Waste/info/foo.trashinfo
</p>

<a id="dot_trashinfo">The contents of *foo.trashinfo* would look like this:</a>

<p class="w3-code">
  [Trash Info]<br />
  Path=/home/andy/src/rmw-project/rmw/foo<br />
  DeletionDate=2019-07-03T16:48:47
</p>

On most *nix and *BSD systems, the desktop trash [has the same
format](https://specifications.freedesktop.org/trash-spec/trashspec-latest.html),
and is located in **~/.local/share/Trash**. You can verify that the
trashinfo format and directory layout is the same.

If you're sure that your Desktop trash is compatible, you can add the
appropriate line to your rmw configuration file.

### Does rmw work on Windows?

Not yet. There's [an open
ticket](https://github.com/theimpossibleastronaut/rmw/issues/71) for
that. But reportedly, rmw works well on the <a
href="https://github.com/ethanhs/WSL-Programs">Windows Subsystem for
Linux</a>.

### Can I use wildcard and regex patterns with rmw?

Yes. For example:

<p class="w3-code">
  rmw *.txt<br />
  rmw test[0-9].txt
</p>

Some complex regex expressions won't work. If you'd like support
for a particular pattern that doesn't already work, please open a
ticket.

### Can rmw be run as a scheduled job to purge expired files?

Yes. The important rule: only the scheduled job should purge.

In your configuration file, keep purging disabled (this is the
default setting):

<p class="w3-code">
  expire_age = 0
</p>

With this setting, rmw never purges when you run it normally. Instead,
a cron job gives the number of days on the command line and writes the
output to a log file:

<p class="w3-code">
  30 4 * * 0 rmw -g45 >> "$HOME/.local/state/rmw-purge.log" 2>&1
</p>

This job runs every Sunday at 04:30. It permanently deletes waste
items that are older than 45 days.

Important details:

- Write the number directly after the option: <code
  class="w3-codespan">-g45</code> or <code
  class="w3-codespan">--purge=45</code>. Do not put a space between
  them. With a space, rmw reads the number as the name of a file to
  delete.
- cron uses a short PATH. If rmw is installed in a place like
  *~/.local/bin*, write the full path to rmw in the cron line.
- If your configuration file contains <code
  class="w3-codespan">force_required</code>, add <code
  class="w3-codespan">-f</code> to the command.

With this setup, two purges can never run at the same time. One small
risk remains: you could restore a file at the same moment the job
deletes it. Desktop trash cleaners have the same small risk.

To stop the log file from growing forever, use logrotate. The log is
in your home directory, so use your own logrotate configuration file.
A good place for it is rmw's data directory, which already exists:
*~/.local/share/rmw/logrotate.conf*. Write the full path to the
log file; logrotate does not understand <code
class="w3-codespan">$HOME</code>:

<p class="w3-code">
  /home/you/.local/state/rmw-purge.log {<br />
  &nbsp;&nbsp;monthly<br />
  &nbsp;&nbsp;rotate 3<br />
  &nbsp;&nbsp;compress<br />
  &nbsp;&nbsp;missingok<br />
  &nbsp;&nbsp;notifempty<br />
  }
</p>

and run it from the same crontab:

<p class="w3-code">
  0 5 * * 0 logrotate --state "$HOME/.local/state/logrotate-rmw.state" "$HOME/.local/share/rmw/logrotate.conf"
</p>
