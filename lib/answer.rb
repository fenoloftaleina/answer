require 'answer/version'
require 'answer/result_object'

module Answer
  class << self
    def new(*args)
      Answer::ResultObject.new(*args)
    end
  end
end
