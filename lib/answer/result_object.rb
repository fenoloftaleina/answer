require 'active_model/serializer'
require 'active_support/all'

Answer::ResultObject = Struct.new(:result_object, :result_success, :result_status, :serializer) do
  def success?
    if @success.nil?
      @success = evaluate_success
    end

    @success
  end

  def object
    @object ||= object_or_errors
  end

  def status
    @status ||= result_status || (nil_result? && 404) || (success? ? 200 : 422)
  end

  def render(controller)
    render_hash = { json: object, status: perfect_status(controller) }
    if serializer
      if object.respond_to?(:each)
        render_hash[:json] = ActiveModel::ArraySerializer.new(
          object, each_serializer: serializer
        )
      else
        render_hash[:serializer] = serializer
      end
    end

    controller.render(render_hash)
  end

  private
  def evaluate_success
    if result_success.nil?
      if nil_result?
        false
      elsif responds_to_errors?
        result_object.errors.empty?
      else
        true
      end
    else
      !!result_success
    end
  end

  def responds_to_errors?
    if @responds_to_errors.nil?
      @responds_to_errors = result_object.respond_to?(:errors)
    end

    @responds_to_errors
  end

  def nil_result?
    result_object.nil?
  end

  def object_or_errors
    if success?
      result_object
    else
      { errors: pack_errors }
    end
  end

  def pack_errors
    if nil_result?
      { base: ['Record not found'] }
    elsif responds_to_errors?
      result_object.errors
    elsif result_object.is_a?(Hash)
      result_object
    else
      { base: Array(result_object) }
    end
  end

  def perfect_status(controller)
    if controller.params[:action] == 'create' && status == 200
      201
    else
      status
    end
  end
end
