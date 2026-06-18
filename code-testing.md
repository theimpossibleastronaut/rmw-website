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

rmw's meson test suite sets a few environment variables to run the code in a
controlled environment (for example, to keep it from scanning the host's real
mount points during a test). They are set by the suite and are not meant for
normal use.

For the current list and a description of each one, see the <a
href="rmw_man.html#environment">ENVIRONMENT section of the manual</a>.
