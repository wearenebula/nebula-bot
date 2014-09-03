# Description:
#   Grabs the latest played last.fm track for a given user.
#
#  Commands:
#   lastfm <username> - displays the latest track in the users last.fm history


module.exports = (robot) ->
    api_key = process.env.NEBULA_LASTFM_API_KEY

    robot.respond /lastfm\s*(.*)$/i, (msg) ->
        username = msg.match[1]

        unless username
            return msg.send "need to include a username after that command!"

        url = """
        http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{username}&api_key=#{api_key}&format=json"""

        robot.http(url)
            .header('Accept', 'application/json')
            .get() (err, res, body) ->

                if err
                    msg.send "There was a problem: #{err.message}"
                else
                    data = JSON.parse body
                    unless data.recenttracks.track
                        return msg.send """
                        Unable to find tracks for that user -
                        have they played anything? are they a user? Who knows"""

                    msg.send """
                    #{username} was last listening to
                    #{data.recenttracks.track[0].name} by
                    #{data.recenttracks.track[0].artist['#text']}"""

