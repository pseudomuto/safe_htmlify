options =
  globalAttributes: ['class']
  tags:
    p: []
    b: []
    script: [] # ignored no matter what!

describe "HtmlifyParser", ->

  describe "#constructor", ->

    context "when not supplied with options", ->

      it "uses default options when none are supplied", ->
        parser = new HtmlifyParser(undefined)
        expect(parser.options).not.toBe null
        expect(parser.options.tags).toEqual {}
        expect(parser.options.globalAttributes).toEqual []

  describe "#parse", ->

    parser = new HtmlifyParser(options)

    it "returns an empty string when no html is given", ->
      expect(parser.parse(undefined)).toBe ''

    context "when using the default options", ->

      it "removes all html", ->
        html = '<p><strong>Some message</strong></p>'
        expect(new HtmlifyParser().parse(html)).toBe 'Some message'

    context "when given tags without attributes", ->

      it "removes non-whitelisted tags", ->
        html = '<strong>This is some bold</strong> content <i>right here</i>'
        expect(parser.parse(html)).toBe 'This is some bold content right here'

      it "leaves whitelisted tags in place", ->
        html = '<b>This is some bold</b> content <i>right here</i>'
        expect(parser.parse(html)).toBe '<b>This is some bold</b> content right here'

      it "leaves nested whitelisted nodes in place", ->
        html = '<strong>This is <p>some</p> bold</strong> content right here'
        expect(parser.parse(html)).toBe 'This is <p>some</p> bold content right here'

      it "strips nested non-whitelisted tags", ->
        html = '<p>This is <strong>some</strong> bold</p> content right here'
        expect(parser.parse(html)).toBe '<p>This is some bold</p> content right here'

    context "when given tags with attributes", ->

      it "keeps attributes if whitelisted for tag", ->
        html = '<p class="my-ptag">This is <strong>some</strong> bold</p> content right here'
        expect(parser.parse(html)).toBe '<p class="my-ptag">This is some bold</p> content right here'

      it "removes non-whitelisted attributes for tag", ->
        html = '<p class="my-ptag" style="color: #fff;">This is <strong>some</strong> bold</p> content right here'
        expect(parser.parse(html)).toBe '<p class="my-ptag">This is some bold</p> content right here'

    context "when dealing with script tags", ->

      it "removes script tags", ->
        html = '<b>Some content</b> <script type="text/javascript" src="//code.jquery.js"></script> <p>here</p>'
        expect(parser.parse(html)).toBe '<b>Some content</b>  <p>here</p>'

      it "remove script tag content", ->
        html = '<script>document.write("some content");</script>'
        expect(parser.parse(html)).toBe ''
