class ClientFilter

  def self.trusted?(remote_address)
    new(Figaro.env.trusted_ips).trusted?(remote_address)
  end

  def initialize(filter_str)
    @trusted = filter_str.split(',').map(&:strip)
  end

  def trusted?(remote_address)
    if @trusted.count == 1 && @trusted.first == '*'
      true
    else
      @trusted.include?(remote_address)
    end
  end

end
