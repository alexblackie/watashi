---
title: Reducing blast radius in my dev env
slug: modern-dev-env-blast-radius
publishDate: 2026-05-03

open_graph_meta:
  title: Reducing blast radius in my dev env
  description: >
    Modern software development terrifies me for many reasons, but more than
    anything what terrifies me the most is the massive dependency supply chain.
    So I've moved my development environments into VMs.
---

<p><big>Modern software development terrifies me for many reasons, but more than
  anything what terrifies me the most is the massive dependency supply chain.</big></p>

Almost daily I hear about some new NPM package that has been brutally
compromised and is uploading every key on your system to some C2 server, or
installing crypto miners, or some new horror yet undiscovered...

A few years ago 1Password added SSH agent support. Since then I've used it
exclusively and it has esuaded a number of my fears. My SSH keys never touch my
disk unencrypted and every use requires biometric attestation through TouchID.
Since then there are many non-1Password solutions that have cropped up (macOS
even has a poorly-documented tool of its own), and if I had to give everyone one
thing to take away from this it's: use those. Get those keys off your disk.

But this only goes so far. My computer is naturally a multi-use machine and has
oodles of uncorrelated data that means a compromise in one area still
compromises my entire life. One NPM package in a consulting project gets popped
and suddenly my Documents folder full of tax documents and financial statements
is compromised, which is arguably worse than having to rotate an SSH key.

A few months ago I decided it was finally time to solve this once and for all. I
had just discovered [Lima](https://lima-vm.io), which solved a lot of the UX
frustrations I've experienced in the past trying to use VMs. Lima allows memory
and CPU overcommit, handles automatic port forwarding, has automatic
mountpoints, supports running normal cloud images... I was able to get a VM with
my dotfiles set up within a couple minutes, and I didn't have to faff around
with port mappings or SSH tunnels or any of that.

It was still a little clunky; I hadn't used `tmux` in many years and had grown
accustomed to native splits in my terminal apps, and so now that I was working
over `ssh` all day I had to retrain my muscle memory for tmux keybindings. And
my yank-to-clipboard vim integration obviously no longer worked... But those
small quality-of-life things were still well worth the security tradeoff for me.

Best yet, **these VMs have no keys in them** -- they just use my 1Password SSH agent
through agent forwarding. I can `git push` in a VM and get prompted for
biometrics on my Macbook. It's a beautiful thing.

I was sold. As of today, I moved the last of my local projects into a new VM. I
went so far as to even uninstall my dotfiles on the host! And I think I can
probably even uninstall Homebrew, God willing...

macOS remains as the human-interface layer, giving me things like "bluetooth
that works" and "suspend", but I finally have the Linux development environment
I've missed. Best of both worlds.

---

But what really sealed the deal for me was this week when I tried
[Zed](https://zed.dev). I was skeptical; I've been a vim/neovim diehard for well
over a decade now, surely some flashy new IDE won't lure me away... Except,
well, it did. Maybe my needs are simpler now, maybe it's the maturity of turning
30 this year, maybe it's really just that good... I don't know. But it got me.

It has a "remote development" feature that lets you run the local, native
application UI, but have all your actions and shells execute remotely. I had
played around with a VSCode extension many years ago that did something similar,
but I was loath to use VSCode so it never stuck. Zed, however, is sticking.

This singular feature means the last of the little clunky bits of the VM
experience is gone. I get a low-latency, native, local editor experience, but
still gain every other benefit of VM-based development. It's truly a relief.

---

The "blast radius" now of a software dependency supply chain compromise is
limited to the correlated codebase(s) for that project. Every VM is now an
isolated security context, with no access to anything on the host, and has no
credentials: no SSH keys, VPN configs, no hardware, no personal documents...

And all it cost was a bit of complexity in cloning my dotfiles a few times and
installing updates now and then.

Neovim over SSH is still entirely fine, but Zed really papers over the remaining
papercuts in a way that makes it more cohesive.

All so I can run `npm i` and breathe slightly easier (but still fearfully).
