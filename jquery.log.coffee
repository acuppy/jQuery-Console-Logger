$ = jQuery

Logger = 
  
  settings:
    active: true
    backtrace: false
    group: true
    collapsed: false
    log_level: 'debug'
  
  levels:
    info: 0
    debug: 1
    warn: 2
    error: 3

  log: (options, log_level, obj) ->
    
    _s = Logger.settings
    _l = Logger.levels
    
    return if !window.console? or !_s.active or (_l[log_level] < _l[_s.log_level]) or !window.console[log_level] 
    
    write_to_console = (msg, obj) ->
      console[log_level]("%s: %o", msg, obj)
      return
      
    if _s.group

      output = "Console log: \"#{obj.selector or "document"}\""

      if _s.collapsed 
        console.groupCollapsed output
      else 
        console.group output
    
    collection = obj.each -> 
      switch $.type options
        when 'string'   then write_to_console options, this
        when 'function' then write_to_console options.call(this), this
        when 'object'   then $.extend _s, options
        when 'boolean'  then _s.active = options

    console.groupEnd() if _s.group
    console.trace()    if _s.backtrace
    collection

$.log = (options) -> 
  try
    _s = Logger.settings
    
    log_level = if $.type(arguments[1]) == 'string' then arguments[1] else 'debug'

    switch $.type options
      when 'string'   then Logger.log options, log_level, $(document)
      when 'function' then Logger.log options(), log_level, $(document)
      when 'object'   then $.extend _s, options
      when 'boolean'  then _s.active = options
      else Logger.log 'Unsupported parameter passed to logger'
  
  catch err
    $.error 'Logger had the following error: '+ err.toString()


$.fn.log = ( msg, log_level, scope ) ->
  try 
    Logger.log msg, log_level, scope or this 
  catch err
    $.error 'Logger had the following error: '+ err.toString()
  
  this