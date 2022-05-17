# frozen_string_literal: true

class ApiConstraints
  attr_reader :version

  def initialize(version:)
    @version = version
  end

  def matches?(req)
    req.headers['API-VERSION'] == "api.mintbarn.v#{version}"
  end
end
