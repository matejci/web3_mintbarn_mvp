# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing, with: :bad_request
    rescue_from ActionController::UnknownFormat, with: :bad_request
    rescue_from ActionController::BadRequest, with: :bad_request
  end

  private

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
