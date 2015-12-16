require 'slack'
require 'giphy'

class Dogbot
  class << self

    def name
      'dogbot'
    end

    def client
      Slack::Client.new token: token
    end

    def token
      ENV['slack_api_token']      
    end

    def channels
      client.channels_list["channels"]
    end

    def list_channels      
      list = channels.map do |c|
        {
          id: c['id'],
          name: c['name'],
          purpose: c['purpose']['value']        
        }
      end
      puts YAML.dump list      
    end

    # chat
    
    def say(to:, from: name, text: , link_names: true, as_user: false, icon_url: nil, profile: nil)
      if profile.present?
        from = profile.name
        icon_url = profile.icon_url
      end
      client.chat_postMessage({channel: to, text: text, username: from, link_names: true, as_user: as_user, icon_url: icon_url})
    end

    def send_gif(to: , from: name, text: , gif_term: , link_names: true, as_user: false, icon_url: nil, profile: )
      gif_url = gif(gif_term)
      message_text = "<#{gif_url} | #{text}>"
      say(to: to, from: from, link_names: link_names, text: message_text, as_user: as_user, icon_url: icon_url, profile: profile)
    end

    def send_gifs(to: , from: name, text: , gif_term:, link_names: true, as_user: false, icon_url: nil, profile: )
      gifs = self.gifs(gif_term)
      say(to: to, from: from, text: text, as_user: as_user, icon_url: icon_url, profile: profile)
      gifs.map do |g|
        say(to: to, from: from, text: "<#{g}| >", as_user: as_user, icon_url: icon_url, profile: profile)
      end
    end

    # shuffling

    def string_shuffle(s)
      s.split("").shuffle.join
    end

    def tmnt_shuffle(s)
      trick_text = "#{s}\n#{string_shuffle(s)}"
      tell_tmnt trick_text      
    end

    # giphy

    def gif(word)
      gif_url = Giphy.translate(word).original_image.url.to_s
    end

    def gifs(term)
      urls = Giphy.search(term).map { |g| g.original_image.url.to_s }
    end

    # interactive

    def interactive
      Interactive.new
      puts 'interactive mode ended. goodbye'
    end

  end
end