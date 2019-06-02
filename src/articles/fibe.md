---
title: Taking Control of Bell Fibe
path: /articles/fibe/
date: 2017-12-23
cover:
  url: https://cdn.blackieops.com/alexblackie/fibe/sfp.jpg
  width: 1920
  height: 537
  alt: Close-up of SFP fibre cable entering a rackmount switch port.
---

<p>
  Consumer ISPs are some of my least favourite companies to deal with. Their
  arrogance and lack of competent support makes for an infinitely-frustrating
  experience for someone like me who has managed a network or two. The pain of
  contacting support with very specific, technical explanations of the exact
  problem you're experiencing only to be told to "restart your PC" makes one's
  hair begin to fade.
</p>

<p>
  I recently moved from the west coast of Canada to the east, and one of the
  benefits gained there was fibre-to-the-apartment availability (something the
  west is just <em>barely</em> beginning to know). Coming from a history of
  cable modems, I was excited to see what was different. I had always dreamed
  of replacing the cable modem with some sort of PCI card in my 1U rack server
  I use for a router, but the complexities involved were always not worth it.
  Fibre, however, is a common standard in datacenter-grade equipment, so I was
  looking forward to maybe finally being able to bypass the horrid consumer
  trashbox Bell was likely to give me.
</p>

<p>
  First however, a little context. Most Fibre connections, from what I can
  tell, are treated by the ISP as DSLs (most well known perhaps through the
  proliferation of the old telephone-based ADSL connections). These connections
  use PPPoE to "log in" to the ISP network and even have a dry-loop phone
  number to tie everything together. While a little crusty and convoluted, it
  works, and I suppose means Bell can reuse existing tooling and expertise
  between ADSL and Fibre, so whatever -- it works, at least.
</p>

<p>
  The first thing I did when the Bell technician left was to undo all the
  things he did and figure out what I was dealing with. I was pleased to see
  the drop from the wall was just standard SFP -- turns out the switch I have
  has two SFP ports! I felt a bit smug, I must confess, as when I fielded the
  question of "can I replace the HomeHub entirely?" the tech was quick to
  confidently tell me "it's impossible."
</p>

<p>
  The gateway ("HomeHub 3000") I was provided had no "bridge mode", but it did
  have an "Advanced DMZ" which let me DHCP a public IP to one device.
  Unfortunately, it would provide the DSLAM private IP address as the gateway,
  thus making the connection unusable until I manually set the gateway to be
  the first address in the subnet... I understood <em>why</em> this happened
  (the gateway on the HomeHub itself would be the DSLAM address and that would
  be fine, since it has the routes over the PPP tunnel), and it let me use my
  own router sort of, but it still bugged me that this HomeHub thing was
  running, probably vulnerable, and it all felt like a giant hack.
</p>

<p>
  So after a bit of research, I found luckily a few other Bell Fibe customers
  had done the gruntwork and I found some obscure forum posts from years ago
  where people had got their enterprise routers working directly using the SFP
  drop from the ONT.
</p>

<p>
  Using information gleaned from a few different sources, I was finally able to
  get my OPNSense machine to get a solid PPPoE connection and a routable
  gateway. Success! The basic setup looks something like this:
</p>

<ul>
  <li>SFP from the ONT in the closet plugs into an SFP slot on my managed switch</li>
  <li>Ethernet Ports 1 &amp; 2 on the switch are in a LACP LAGG</li>
  <li>The LAGG is set to pass untagged traffic over VLAN 35</li>
  <li>The SFP slot is set to tag packets explicitly with VLAN 35</li>
  <li>
    The OPNSense WAN interface is set to IPv4 PPPoE
    <ul>
      <li>I configured the LACP LAGG within OPNSense</li>
      <li>I created a disabled OPT interface and associated it to the LAGG interface (for whatever reason, OPNSense/pfSense does not show LAGG devices for PPPoE, but it does show all interfaces)</li>
      <li>The username is set to the one configured in the HomeHub</li>
      <li>The password is one I set myself from within my Bell account settings on their website</li>
      <li>The interface for the PPPoE device is set to the OPT interface I created</li>
    </ul>
  </li>
  <li>I had to do a "Save &rarr; Apply Changes" cycle on the WAN interface after configuring everything to force it to reconnect, and going back to the dashboard I had a green gateway and public IPv4 address.</li>
</ul>

<p>
  I was somewhat hoping that if I swapped in my own hardware I would be able to
  find a way to negotiate for an IPv6 allocation (as the sales rep I spoke to
  before ordering assured me IPv6 was supported), but alas the IPV6CP parameter
  negotiation fails when establishing the tunnel and nothing I've tried has had
  results. At the time of writing, holiday season is approaching its climax, so
  my option is to wait a week or so and complain to support and see what they
  say (maybe it has to be enabled for my account or some garbage like that).
</p>

<p>
  My reasoning for using a LAGG for the WAN connection to the router was
  because I had a gigabit connection, and unfortunately only the budget for
  GigE equipment. By using a LAGG, I avoid transmission overhead over a single
  gigabit wire (which usually means capping around 900mbps), and allows me to
  take advantage of a little bit of burst speed Bell provides (going near
  1.2Gbps).
</p>

<p>
  However, it's all-for-naught, if I am to be honest. I have been unable, using
  my own equipment, to push a full gigabit over the WAN. <em>Something</em> in
  my setup can't handle more than ~750mbps, and as of yet I've been unable to
  diagnose which component it is. My working theory is the SFP ports on the
  switch are only wired at gigabit (whereas my other switches have had 10GbE
  SFP+) and within there lies some sort of overhead or limits.
</p>

<p>
  For now I'm willing to live with "only" 750mbps WAN throughput, but in the
  future I may look into SFP+/10GbE switches as an upgrade path. I was getting
  greater-than-gigabit speedtest results using the HomeHub, so I know the fibre
  connection itself it capable of more than I am able to push through it.
</p>

<hr>

<p>
  Overall, I'm incredibly pleased with how this all turned out. Finally, my
  dream of having an entirely self-controlled home network has come to reality.
  There are no mysterious black boxes to trust, no ISP backdoors into my
  network, and no unpatchable, publicly-exposed embedded devices.
</p>

<p>
  With a couple equipment upgrades, and possibly a call to support to try and
  get IPv6 sorted, this could be a near-perfect setup.
</p>
