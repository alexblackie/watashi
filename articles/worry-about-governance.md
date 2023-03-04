title: "Worry about software governance, not license"
publishDate: "2023-03-04"
openGraphTitle: "Worry about software governance, not license"
openGraphDescription: >
  Recently, an early proposal to add basic usage telemetry to the Go toolchain
  has made the rounds, and many people are livid that such a move would come
  from a privacy-focused and ethically-aligned company like Google...

---

<big>

Recently, an [early proposal to add basic usage telemetry][0] to the Go
toolchain has made the rounds, and many people are livid that such a move would
come from a privacy-focused and ethically-aligned company like&nbsp;Google...

</big>

[0]: https://github.com/golang/go/discussions/58409

Personally, I am neither surprised nor disappointed by the proposal. I think
the statistics they want to collect are benign, and their transparency around
it seems reassuring. I have more issues with `GOPROXY` than I do with the
telemetry proposal.

The outrage from the community I believe is not so much about the telemetry
itself, but rather a response to the proverbial last straw. This proposal
is a reminder to everyone in the Go community that their favourite language is
controlled singularly by a private entity -- a private entity with a history of
data abuse, widespread surveillance, and extreme political influence.

This kerfuffle with Go highlights something often overlooked when it comes to
"free software:" the governance model. Go is BSD-licensed, so it is *legally*
unencumbered, but this does not mean it is a "free" ecosystem.

I think in this case it's important to have a baseline comparison -- the
languages I'm using most these days are Elixir and Rust, so let's use those.

Elixir's (or perhaps more importantly the BEAM's) governance is handled by the
non-profit Erlang Ecosystem Foundation ("ErlEF"). It has dozens of sponsors,
board elections, and nothing about it is controlled by any one entity.

Rust's governance is -- you might have guessed -- handled by a non-profit
organization, The Rust Foundation. It also has a healthy number of sponsors,
board elections, and all the rest of it.

This is what a healthy software ecosystem looks like. This is what successful
governance must look like for a long-term software ecosystem.

The problem with Go is that it has no such governance. Go is first and foremost
a Google-run project. All decisions run through a small team of Google
employees. It's not about how much you do or do not trust Russ or Rob or
whomever, it's about whether you trust who runs the infrastructure and pays for
their work, because that's who will call the shots in the end.

---

Go's long-term survival likely depends on if it can divorce itself from Google.
Any fork of Go would need to rival Google's influence, so it might not be
successful without Google's blessing. And Google's blessing likely doesn't come
without some sort compromise.

Let's look at a similar example: C# and .NET. Microsoft has tried in recent
years to divorce itself from .NET to encourage more ecosystem development. They
moved .NET annd its biggest libraries to a permissive license and they even set
up a foundation! But did it work?

Well, kind of. For one, the .NET website, docs, and downloads all still live
under `microsoft.com` -- that's hardly independent. And Visual Studio itself is
still a proprietary software product, and still only runs on Windows. Sure,
it's technically possible to write and run .NET software on Linux in vim, but
it is still a significantly worse experience than using the "full" Visual
Studio, and you'll often struggle to find docs or examples to support you
(though this is improving over time).

So .NET has a lot of work to do still to move out of its parents' house. Is it
on the right path? I think so. But it's a long and messy process, and they're
fighting decades of decisions, habits, and expectations.

---

Will I be rewriting the piles of Go I've written over the past few years?
Definitely not. Go is still an excellent language with an excellent
toolchain... But would I choose Go for a new project today? Probably not.

At the least, I will endeavour to be more discerning going forward about what
technology I choose and take the time to ensure its governance model is
independent, distributed, and accountable.

Like Rust. Or Elixir. Or even Python, if one must.
