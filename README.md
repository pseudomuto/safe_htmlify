# SafeHtmlify

[![Build Status](https://travis-ci.org/pseudomuto/safe_htmlify.png)](https://travis-ci.org/pseudomuto/safe_htmlify)

A jQuery plugin that strips HTML from strings except in cases where you say otherwise!

The main purpose is to be able to show user-generated HTML on a web page without having to worry about scripts/styles breaking your whole site. This is accomplished by:

* only allowing specifically whitelisted tags and attributes
* not allowing script tags (even if you try to whitelist `script`)

## Usage

By default all HTML will be removed

    var safeHTML = $.safeHtmlify('<p><strong>Some message</strong> here</p>');
    // safeHTML === 'Some message here'

You can whitelist tags by supplying an options hash with `tags`

    var safeHTML = $.safeHtmlify('<p><strong>Some message</strong> here</p>', {
      tags: {
        p: []
      }
    });

    // safeHTML === '<p>Some message here</p>'

You can allow attributes on individual tags in the options hash

    var safeHTML = $.safeHtmlify('<p class="ptag" style="color: #fff"><strong>Some message</strong> here</p>', {
      tags: {
        p: ['class']
      }
    });

    // safeHTML === '<p class="ptag">Some message here</p>'

You can globally allow attributes (on any whitelisted tag) by supplying an options hash with `globalAttributes`

    var safeHTML = $.safeHtmlify('<p class="ptag" style="color: #fff"><strong>Some message</strong> here</p>', {
      tags: {
        p: []
      },
      globalAttributes: ['class']
    });

    // safeHTML === '<p class="ptag">Some message here</p>'

## Contributing

Same as always...fork it, change it, push it, pull it.

### Running the tests

For this you'll want to have two terminals available

* In one terminal, run `lineman run` - this will watch for changes and build as necessary
* In another terminal, run `lineman spec` or `lineman spec-ci`
