# 私 [![Build Status](https://ci.blackieops.com/job/watashi-tests/badge/icon)](https://ci.blackieops.com/job/watashi-tests)

This is a WIP attempt to rebuild my website with more software for some reason.

## Development

This is a bare Rack application. Ensure you have the latest Ruby and Bundler.

```
$ bundle
$ bundle exec rackup
```

The app will start on `[::1]:9292`.

## Testing

There is an RSpec test suite that you should always run.

```
$ bundle exec rspec
```
