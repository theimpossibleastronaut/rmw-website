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

### How does rmw choose which waste folder to use?

*(since 0.10.0)*

rmw works with no configuration. It moves a removed file to a trash folder
on the same file system as the file; it does not copy files between file
systems. To pick one, rmw looks in this order:

1. The waste folders in your configuration file, if you set any.
2. The [FreeDesktop.org Trash
   specification](https://specifications.freedesktop.org/trash-spec/trashspec-latest.html)
   trash for that file system: the home trash (<code
   class="w3-codespan">~/.local/share/Trash</code>, the same trash your
   desktop uses) for files on your home file system, or a trash at the top
   of the file system (for example, <code
   class="w3-codespan">/mnt/disk/.Trash-1000</code>) for other file systems.
   If one already exists, rmw uses it; if not, rmw creates it when first
   needed.

rmw does not create a trash folder on file systems that are not meant to
hold one, such as temporary (<code class="w3-codespan">tmpfs</code>) or
network file systems. On those, if no configured waste folder matches,
rmw does not remove the file. This is the same as how your desktop file
manager behaves. A trash folder that is already present on such a file
system is still used.

To keep rmw's files separate from the desktop trash, uncomment <code
class="w3-codespan">WASTE = $HOME/.local/share/Waste</code> in your
configuration file.

Run <code class="w3-codespan">rmw -l</code> to list the waste folders rmw
knows about, or <code class="w3-codespan">rmw -lv</code> to also see the
trash folders rmw would create on other file systems.

### Can I keep a waste folder but stop putting new files in it?

*(since 0.10.0)*

Yes. Add the <code class="w3-codespan">no-add</code> attribute to the
folder in your configuration file:

<p class="w3-code">
  WASTE = /path/to/folder, no-add
</p>

rmw will not move new files into a <code class="w3-codespan">no-add</code>
folder, but it still lists the folder, restores files from it, and purges
old files in it. This is useful when you want to empty an old waste folder
over time without adding anything new to it.

### Does rmw work on Windows?

No, and native Windows support is not planned. rmw targets POSIX systems
(Linux, the BSDs, and macOS). It does run on the <a
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
