# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing, with: :bad_request
    rescue_from ActionController::UnknownFormat, with: :bad_request
    rescue_from ActionController::BadRequest, with: :bad_request
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  end

  private

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def invalid_record(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
