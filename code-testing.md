---
title: Code Testing
layout: default
---
<ul>
  <li><a href="#general_testing">General Testing</a></li>
  <li><a href="#env_vars">Environmental Variables</a></li>
</ul>

<h2 id="general_testing">General Testing</h2>

Run <code class="w3-codespan">meson test</code> from your build
directory. This covers most of rmw's operations. Some tests need a
tool or a permission that your system may not have; those report
<code class="w3-codespan">SKIP</code> instead of failing.

If <a
href="https://github.com/wolfcw/libfaketime">faketime</a> is installed,
you can also run the tests with a clock set 14 years ahead. This checks
that rmw still handles dates correctly after the year 2038:

<p class="w3-code">
meson test --setup=epochalypse
</p>

If there's a test missing, please open a ticket.

<h2 id="env_vars">Environmental Variables</h2>

rmw's meson test suite sets a few environment variables to run the code in a
controlled environment (for example, to keep it from scanning the host's real
mount points during a test). They are set by the suite and are not meant for
normal use.

For the current list and a description of each one, see the <a
href="rmw_man.html#environment">ENVIRONMENT section of the manual</a>.
