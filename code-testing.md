---
title: Code Testing
layout: default
---
<ul>
  <li><a href="#general_testing">General Testing</a></li>
  <li><a href="#env_vars">Environmental Variables</a></li>
</ul>

<h2 id="general_testing">General Testing</h2>

Using <code class="w3-codespan">ninja test</code> and <code
class="w3-codespan">meson test --setup=fake_media_root</code> will
cover most of rmw's operations. If there's a test missing, please open
a ticket.

<h2 id="env_vars">Environmental Variables</h2>
<div class="w3-panel w3-pale-red w3-leftbar w3-border-red">
  <p>These variables are set by rmw's meson test suite to run the code in a
  controlled environment. They are not meant for normal use. Setting them
  yourself is strongly discouraged and can make rmw behave in unexpected
  ways.</p>
</div>

<div class="w3-panel w3-border">
  <p><b>RMW_DISCOVERY</b> (v0.10.0)</p>
By default, rmw scans the real mount points on your machine to find
FreeDesktop <code class="w3-codespan">$topdir</code> trash folders. Set
this variable to <b>off</b> to turn that scan off. This is useful in tests,
so rmw does not look at the real mounts on the test machine. Any other
value, or leaving the variable unset, keeps the scan on.

<p class="w3-code">
  RMW_DISCOVERY=off rmw FILE(s)
</p>
</div>

<div class="w3-panel w3-border">
  <p><b>RMW_FAKE_HOME</b> (v0.8.0)<br />
  (replaces RMWTEST_HOME, introduced in v0.7.03)</p>
  <p class="w3-text-orange"><b>Deprecated.</b> It will be removed in a
  future release. To set up a test home, set <code
  class="w3-codespan">HOME</code> (and <code
  class="w3-codespan">XDG_DATA_HOME</code> / <code
  class="w3-codespan">XDG_CONFIG_HOME</code>) yourself. To turn mount
  discovery off, use <b>RMW_DISCOVERY</b> (above) instead of relying on this
  variable.</p>
Instead of using $HOME, rmw will use $RMW_FAKE_HOME. The configuration
file and default waste directory will be written relative to
$RMW_FAKE_HOME.

<p class="w3-code">
  RMW_FAKE_HOME=$PWD/footest
</p>

While set, using rmw to move any files that reside on the same file
system as *$PWD/footest* will be moved to the waste directories under
*$PWD/footest* and rmw will use the configuration file under
*$PWD/footest*.
</div>

<div class="w3-panel w3-border">
<p><b>RMW_FAKE_YEAR</b> (v0.7.07)<br />
(replaces RMWTRASH=fake-year, introduced in v0.4.01)</p>

If set to *true* when rmw'ing a file, the year 1999 will be written to
the DeletionDate value in the .trashinfo file (for testing the purge
feature).

<p class="w3-code">
  RMW_FAKE_YEAR=true rmw FILE(s)
</p>

Then running rmw with the purge option will find the items expired and
permanently delete them.
</div>

<div class="w3-panel w3-border">
<p><b>RMW_FAKE_MEDIA_ROOT</b> (v0.7.07)(removed in v0.9.3)</p>

If set to **true** when rmw-ing a file, relative paths will be written
to the Path key of a .trashinfo file. rmw is faked into believing that
all waste directories are at the top level of a device or removable
medium (see also: <a
href="https://github.com/theimpossibleastronaut/rmw/issues/299">issue
299</a>).

<p class="w3-code">
RMW_FAKE_MEDIA_ROOT=true rmw FILE(s)
</p>
</div>


