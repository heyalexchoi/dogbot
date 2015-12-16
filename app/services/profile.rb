class Profile
  attr_accessor :name, :icon_url
  class << self

    def ruby
      profile = Profile.new
      profile.name = 'Ruby Anaya'
      profile.icon_url = 'https://pbs.twimg.com/profile_images/449242540110139392/D4JO7BZs.jpeg'
      profile
    end

    def dog
      profile = Profile.new
      profile.name = 'dogbot'
      profile.icon_url = 'http://memesvault.com/wp-content/uploads/High-Dog-Picture-13.jpg'
      profile
    end

    def profile_names
      ['ruby', 'dog']
    end

    def with_name(name)
      self.send(name)
    end

  end
end