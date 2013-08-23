{TextListener} = require (process.env.HUBOT_HALL_REQUIRE_PATH || 'hubot')

module.exports = (robot) ->
  XRegExp = require('xregexp').XRegExp;
  console.log "Loading xregexp"

  robot.respond = (regex, callback) ->
    re = regex.toString().split('/')
    re.shift()
    modifiers = re.pop()

    if re[0] and re[0][0] is '^'
      robot.logger.warning \
        "Anchors don't work well with respond, perhaps you want to use 'hear'"
      robot.logger.warning "The regex in question was #{regex.toString()}"

    pattern = re.join('/')
    name = robot.name.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&')

    if robot.alias
      alias = robot.alias.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&')
      newRegex = new XRegExp(
        "^[@]?(?:#{alias}[:,]?|#{name}[:,]?)\\s*(?:#{pattern})"
        modifiers
      )
    else
      newRegex = new XRegExp(
        "^[@]?#{name}[:,]?\\s*(?:#{pattern})",
        modifiers
      )

    console.log "Regex is #{newRegex}"

    robot.listeners.push new TextListener(robot, newRegex, callback)