```
  ___  _            ______ _            _    _      _      ______ _
 / _ \| |           | ___ \ |          | |  (_)    ( )     | ___ \ |
/ /_\ \ | _____  __ | |_/ / | __ _  ___| | ___  ___|/ ___  | |_/ / | ___   __ _
|  _  | |/ _ \ \/ / | ___ \ |/ _` |/ __| |/ / |/ _ \ / __| | ___ \ |/ _ \ / _` |
| | | | |  __/>  <  | |_/ / | (_| | (__|   <| |  __/ \__ \ | |_/ / | (_) | (_| |
\_| |_/_|\___/_/\_\ \____/|_|\__,_|\___|_|\_\_|\___| |___/ \____/|_|\___/ \__, |
                                                                           __/ |
                                                                          |___/
```
[![Build Status](http://ci.alexblackie.com/buildStatus/icon?job=self)](http://ci.alexblackie.com/job/self/)

This is a [Middleman][middleman] project, hosted on [the Rackspace
Cloud][cloud], and managed through [Jenkins][jenkins] for testing and
auto-deployments.

## 0. Prerequisites

* Git
* Ruby 1.9.3+
* Bundler
* POSIX-compliant OS (read: not Windows)

## 1. Setting up

* Get it: `git clone https://github.com/alexblackie/self.git`
* Install: `bundle install`
* Start a development server: `bundle exec middleman server`
* Open it: `open http://localhost:4567/` (OSX; `xdg-open` in most Linux DEs)

## 2. Styleguide
### 2.1 SASS

I'm using an object-oriented approach to class and variable naming. Basically,
variables and (most) classes are named to be as general and override-able as
possible.

Here's some basic examples:

* Instead of `$text-color`, we use `$color-text` because the variable is, at its
  most general, a "color", not a "text". We then become more specific in the
  succeeding sections (it's a color, and it's a color of text). We modify the
  root namespace with suffixes.
* Instead of `$light-color-text`, we use `$color-text-light`, as `light` is a
  modifier of the color of the text.
* Instead of `.post .header`, we use `.post-header`. This makes it much easier
  to override things without unnecessary chaining or specificity. `!important`
  is a sin, and so is using direct-decendant selectors for the sole purpose of
  overriding.

### 2.2 Alignment

When logical, it is preferred you align variables, properties, or other lists of
similar content to their delimiter (a colon, rocketship, or equal sign, for
example).

**BAD:**
```sass
.this-is-bad
  display: block
  text-decoration: overline
  color: pink
  border-bottom: 2px solid green
```

**GOOD:**
```sass
.this-is-correct
  display:         block
  text-decoration: overline
  color:           pink
  border-bottom:   2px solid green
```

This ensures readability, and just looks a lot cleaner.

### 2.3 Header blocks

In large files, abstraction into partials is always a good idea. However,
sometimes there is not enough to suffice an entire partial. In this case, we use
comment header blocks to indicate each section. These header blocks are
preceeded by two empty lines, and are directly succeeded by their content.

An example:
```sass
//-----------------------------------------------------------------------------
// Pagination: Post
//-----------------------------------------------------------------------------
.post-pagination
  +span-columns(6 omega)
  display: block
  height:  $height-pagination

  .post-pagination-dot
    border-radius: 100%


//-----------------------------------------------------------------------------
// Pagination: Photo
//-----------------------------------------------------------------------------
.photo-pagination
  background: blue
  border:     10px solid grey

  .photo-pagination-next
    float: right
```

### 2.4 Property Order

Properties under each SASS declaration should be ordered as follows:

```sass
.example
  [mixins]
  [box-model-related]
  [typography]
  [colors]
  [effects]
```

**Note:** I categorize `border` as "effects", even though it is technically part
of the box model.

An example:

```sass
.example-with-content
  +pie-clearfix
  +span-columns(4)
  +background-image($example-variable)
  display:          block
  height:           $height-example
  font-size:        2em
  line-height:      1.4em
  color:            $color-text
  background-color: $background-example
  border:           1px dotted green
  border-radius:    20px
```

### 2.5 Property Nesting

Property nesting should be used unless there is only a single property nested.

For example,

**BAD:**
```sass
.example
  font:
    size:      12px
  line-height: 1.75em
```

**GOOD:**
```sass
.example
  font-size:   12px
  line-height: 1.75em
```

## 3. License

Do whatever the fuck you want: I couldn't care less.

[cloud]:     https://rackspace.com/cloud/servers/
[middleman]: http://middlemanapp.com/
[jenkins]:   http://jenkins-ci.org/
