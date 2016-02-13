class UpdateError < StandardError
  def self.standard
    "That cannot be updated in that way."
  end
end
