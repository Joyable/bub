require './lib/slack_commands/slack_command'
class StatusCommand < SlackCommand
  def self.aliases
    %w(status info list)
  end

  def run
    claims_info = claims.info
    deploy_info = deploys.info
    APPS.each do |app|
      claim = claims_info[app]
      claim_message =
        if claim.nil?
          "*never claimed*"
        elsif claim[:expires_at] > Time.now
          "*#{claim[:user]}'s* for the next #{time_ago_in_words(claim[:expires_at])}"
        else
          "*free*"
        end

      message = "#{app}: #{claim_message}"
      send_to_slack(message)
    end

    deploy_info.each do |app|
      message = "#{app['user']} is currently deploying to #{app['app']}"
      send_to_slack(message)
    end
  end
end
