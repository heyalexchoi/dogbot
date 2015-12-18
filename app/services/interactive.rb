class Interactive
  attr_accessor :profile, :channel

  def initialize
    @profile = Profile.ruby
    @channel = '#prngprng'
    puts 'starting interactive mode. type "quit" to quit'
    puts "you are currently chatting as #{profile.name} in #{channel}. you can chat as:"
    Profile.profile_names.each { |n| puts "- #{n}"}

    puts 'change profile with /profile and change channels with /join'

    iloop    
  end

  def iloop
    while true
      print "@#{profile.name} (#{channel}):"
      command = gets.chomp

      return if quit_commands.include?(command)    

      components = command.split(' ')

      if components.first == '/join'
        @channel = components.second
        redo
      end    

      if components.first == '/profile'
        name = components.second
        puts "no such profile" and iloop unless Profile.profile_names.include?(name)
        @profile = Profile.with_name(name)        
        redo
      end

      if components.first == '/gif'
        terms = components.drop(1).join
        Dogbot.send_gif(to: channel, profile: profile, gif_term: terms, text: '')
        redo
      end

      if components.first == '/gifs'
        terms = components.drop(1).join
        Dogbot.send_gifs(to: channel, profile: profile, gif_term: terms, text: '')
        redo
      end

      # add /join, /profile, /giphy, /giphybomb
      result = Dogbot.say(to: channel, profile: profile, text: command)
      puts result unless result['ok']
    end    
  end

  def quit_commands
    ['quit', 'exit']
  end

end