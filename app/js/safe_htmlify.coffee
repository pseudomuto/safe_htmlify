$ = @jQuery

TEXT_NODE = 3

DEFAULT_OPTIONS =
  tags: {}
  globalAttributes: []

class HtmlifyParser
  constructor: (options) ->
    @options = options || DEFAULT_OPTIONS

    attrs = @options.globalAttributes
    for tag of @options.tags
      @options.tags[tag] = _.union @options.tags[tag], attrs

  parse: (html) ->
    return '' unless html?

    that = @
    output = []
    nodes = $.parseHTML(html)

    _.each nodes, (node) ->
      if node.nodeType is TEXT_NODE
        output.push node.textContent
      else
        output.push that._makeElement(node)

    output.join ''

  _makeElement: (node) ->
    output = []
    validTag = _.contains (key for key of @options.tags), node.nodeName.toLowerCase()

    output.push @_makeOpenTag(node) if validTag
    output.push @parse($(node).html())
    output.push "</#{@_nodeName(node)}>" if validTag

    output.join ''

  _makeOpenTag: (node) ->
    nodeName = @_nodeName node
    output = []
    output.push "<#{nodeName}"

    tag = @options.tags[nodeName]
    _.each node.attributes, (attr) ->
      if _.contains tag, attr.name
        output.push " #{attr.name}=\"#{attr.value}\""

    output.push '>'
    output.join ''

  _nodeName: (node) ->
    node.nodeName.toLowerCase()

@HtmlifyParser = HtmlifyParser

$.safeHtmlify = (html, options) ->
  new HtmlifyParser(options).parse html
