---
title: FAQ
layout: default
---

Anything that isn't covered here may be found on the <a
href="extra_tips.html">Extra Tips</a> page.

**What is your release cycle?**

It varies, averaging once or twice a year. If bugs are found and
reported, a release will happen sooner depending on the severity.
Upcoming releases can be tracked using the [Milestones
page](https://github.com/theimpossibleastronaut/rmw/milestones). The
dates may change but Andy tries to keep them as up-to-date as
possible.

**Can rmw replace rm? Can I alias rmw to rm?**

I don't recommend it. Many other utilities use rm in the background and
you'd wind up with a very full trash can. Also, rmw doesn't have the
same command line options as rm (see also: an <a
href="https://github.com/theimpossibleastronaut/rmw/discussions/305">extended
discussion</a>)

**How do I know if rmw is compatible with my Desktop trash?**

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

**Does rmw work on Windows?**

Not yet. There's [an open
ticket](https://github.com/theimpossibleastronaut/rmw/issues/71) for
that. But reportedly, rmw works well on the <a
href="https://github.com/ethanhs/WSL-Programs">Windows Subsystem for
Linux</a>.

**Can I use wildcard and regex patterns with rmw?**

Yes. For example:

<p class="w3-code">
  rmw *.txt<br />
  rmw test[0-9].txt
</p>

Some complex regex expressions won't work. If you'd like support
for a particular pattern that doesn't already work, please open a
ticket.

**Can rmw be run as a scheduled job to purge expired files?**

Yes, if you make the scheduled job the only thing that ever purges.
Keep purging disabled in your configuration file (this is the
default):

<p class="w3-code">
  expire_age = 0
</p>

With that setting, normal rmw runs never purge anything. Then let a
cron job pass the age explicitly and append the output to a log:

<p class="w3-code">
  30 4 * * 0 rmw -g45 >> "$HOME/.local/state/rmw-purge.log" 2>&1
</p>

This permanently deletes waste items older than 45 days every Sunday
at 04:30. A few things to watch for:

- The number must be attached to the option: <code
  class="w3-codespan">-g45</code> or <code
  class="w3-codespan">--purge=45</code>. With a space in between,
  rmw treats the number as a file to be trashed.
- cron jobs run with a minimal PATH; use the full path to rmw if it's
  installed somewhere like *~/.local/bin*.
- If you've uncommented <code class="w3-codespan">force_required</code>
  in your configuration file, add <code class="w3-codespan">-f</code>
  to the command.

Because interactive runs can't purge with this setup, two purges can
never collide. A narrow window remains if you restore a file at the
same moment the scheduled job is deleting it — the same small risk any
desktop trash auto-cleaner has.

To keep the log from growing, rotate it with logrotate. Since the log
lives in your home directory, use a small user-level configuration
(absolute path required, e.g. *~/.config/rmw/logrotate.conf*):

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
  0 5 * * 0 logrotate --state "$HOME/.local/state/logrotate-rmw.state" "$HOME/.config/rmw/logrotate.conf"
</p>
