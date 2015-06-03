
module.exports = (env, callback) ->
  ### Paginator plugin. Defaults can be overridden in config.json
      e.g. "paginator": {"perPage": 10} ###

  defaults =
    template: 'index.jade' # template that renders pages
    webinars: 'webinars' # directory containing contents to paginate
    first: 'index.html' # filename/url for first page
    filename: 'page/%d/index.html' # filename for rest of pages
    perPage: 2 # number of webinars per page

  # assign defaults any option not set in the config file
  options = env.config.paginator or {}
  for key, value of defaults
    options[key] ?= defaults[key]

  getWebinars = (contents) ->
    # helper that returns a list of webinars found in *contents*
    # note that each article is assumed to have its own directory in the webinars directory
    webinars = contents[options.webinars]._.directories.map (item) -> item.index
    # skip webinars that does not have a template associated
    webinars = webinars.filter (item) -> item.template isnt 'none'
    # sort article by date
    webinars.sort (a, b) -> b.date - a.date
    return webinars

  class PaginatorPage extends env.plugins.Page
    ### A page has a number and a list of webinars ###

    constructor: (@pageNum, @webinars) ->

    getFilename: ->
      if @pageNum is 1
        options.first
      else
        options.filename.replace '%d', @pageNum

    getView: -> (env, locals, contents, templates, callback) ->
      # simple view to pass webinars and pagenum to the paginator template
      # note that this function returns a funciton

      # get the pagination template
      template = templates[options.template]
      if not template?
        return callback new Error "unknown paginator template '#{ options.template }'"

      # setup the template context
      ctx = {@webinars, @pageNum, @prevPage, @nextPage}

      # extend the template context with the enviroment locals
      env.utils.extend ctx, locals

      # finally render the template
      template.render ctx, callback

  # register a generator, 'paginator' here is the content group generated content will belong to
  # i.e. contents._.paginator
  env.registerGenerator 'paginator', (contents, callback) ->

    # find all webinars
    webinars = getWebinars contents

    # populate pages
    numPages = Math.ceil webinars.length / options.perPage
    pages = []
    for i in [0...numPages]
      pageWebinars = webinars.slice i * options.perPage, (i + 1) * options.perPage
      pages.push new PaginatorPage i + 1, pageWebinars

    # add references to prev/next to each page
    for page, i in pages
      page.prevPage = pages[i - 1]
      page.nextPage = pages[i + 1]

    # create the object that will be merged with the content tree (contents)
    # do _not_ modify the tree directly inside a generator, consider it read-only
    rv = {pages:{}}
    for page in pages
      rv.pages["#{ page.pageNum }.page"] = page # file extension is arbitrary
    rv['index.page'] = pages[0] # alias for first page
    rv['last.page'] = pages[(numPages-1)] # alias for last page

    # callback with the generated contents
    callback null, rv

  # add the article helper to the environment so we can use it later
  env.helpers.getWebinars = getWebinars

  # tell the plugin manager we are done
  callback()
