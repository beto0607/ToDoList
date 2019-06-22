class ApplicationController < ActionController::API
  def not_found
    render json: { error: "not_found" }
  end

  def authorize_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render_error(:unauthorized, "Unauthorized", e.message)
    rescue JWT::DecodeError => e
      render_error(:unauthorized, "Unauthorized", e.message)
    end
  end

  def render_error(status, title, message)
    errors = [{ "title": title, "detail": message }]
    render json: JSONAPI::Serializer.serialize_errors(errors), status: status
  end

  def serialize_model(model, options = {})
    options[:is_collection] = false
    JSONAPI::Serializer.serialize(model, options)
  end

  def serialize_models(models, options = {})
    options[:is_collection] = true
    JSONAPI::Serializer.serialize(models, options)
  end
end
