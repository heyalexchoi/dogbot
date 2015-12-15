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

    def tmnt_id
      'C0D117U4A'
    end

    # search channels for id for name?
    def say(to:, from: name, text: , link_names: true)
      client.chat_postMessage({channel: to, text: text, username: from, link_names: true})
    end

    def tell_tmnt(text)
      say(tmnt_id, text)
    end

    def string_shuffle(s)
      s.split("").shuffle.join
    end

    def tmnt_shuffle(s)
      trick_text = "#{s}\n#{string_shuffle(s)}"
      tell_tmnt trick_text      
    end

    def gif(word)
      gif_url = Giphy.translate(word).original_image.url.to_s
    end

    def gifs(term)
      urls = Giphy.search(term).map { |g| g.original_image.url.to_s }
    end

    def send_gif(to: , from: name, text: , gif_term: , link_names: true)
      gif_url = gif(gif_term)
      message_text = "<#{gif_url} | #{text}>"
      say(to: to, from: from, link_names: link_names, text: message_text)
    end

    def send_gifs(to: , from: name, text: , gif_term:, link_names: true)
      gifs = self.gifs(gif_term)
      say(to: to, from: from, text: text)
      gifs.map do |g|
        say(to: to, from: from, text: "<#{g}| >")
      end
    end

  end
end