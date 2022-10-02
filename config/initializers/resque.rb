
Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_rescue.log"))
Resque.logger.level = Logger::INFO
