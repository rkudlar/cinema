class ApplicationService
  def initialize(**args); end

  def self.call(**args, &block)
    new(**args).call(&block)
  end

  def call; end
end
