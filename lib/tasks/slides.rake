require 'optparse'


namespace :slides do |args|

  # desc 'Sets up logging - should only be called from other rake tasks'
  # task setup_logger: :environment do
  #   logger           = Logger.new(STDOUT)
  #   logger.level     = Logger::INFO
  #   Rails.logger     = logger
  # end

  desc 'Import images from given path: rake slides:import'
  task :import => :environment do
    options = {}
    o = OptionParser.new(args) do |opts|      
      opts.banner = "Usage: rake user:create [options]"
      opts.on("-u", "--user {username}","username") { |user| options[:user] = user }
      opts.on("-p", "--path {path}","path") { |path|
        Dir.chdir options[:path] = path
      }
    end

    o.order! {}
    o.parse!

    options[:path] ||= Dir.pwd
    if options[:user].to_s == ''
      puts "User cannot be empty"
      exit 68
    end

    begin
      warn_if_tenants_empty
      Apartment::Tenant.switch(options[:user])
    rescue Apartment::TenantNotFound => e
      puts e.message
      exit 69
    end

    Dir.glob("#{options[:path]}/**/*.jpg", File::FNM_CASEFOLD).sort { |file|

      dir, filename = file.match(/.+\/(.+)\/(.+)/).captures

      @album = (Album.find_by name: dir) || (Album.create name: dir)

      @photo = Rack::Test::UploadedFile.new(file, "image/jpeg")
      @slide = @album.slides.build(photo: @photo)        

      if @slide.save
        p "#{dir} - #{file} - saved"
      else
        p "#{dir} - #{file} - failed - #{@slide.errors.full_messages.join(' ')}"
      end

    }
    exit 0
  end
end
