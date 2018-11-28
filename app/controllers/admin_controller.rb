class AdminController < ApplicationController
  include TournamentController

  abstract!

  helper UiHelper
  layout 'admin'

  before_action :authenticate_user!
  before_action :authenticate_tournament_user!

  rescue_from(ActiveRecord::RecordNotFound, with: :render_admin_404)

  def authenticate_tournament_user!
    unless current_user.is_tournament_user?(@tournament.id) || current_user.staff?
      redirect_to new_user_session_path
    end
  end

  def execute_graphql(mutation, input_type, input, output)
    query_string = "mutation #{mutation}($input: #{input_type}!) {#{mutation}(input: $input) #{output}}"
    query_variables = {"input" => input.deep_transform_keys { |key| key.to_s.camelize(:lower) }}

    result = Schema.execute(
      query_string,
      variables: query_variables,
      context: {
        tournament: current_tournament,
        current_user: current_user
      }
    )

    raise RuntimeError, result['errors'] if result['errors'].present?

    result['data'][mutation]
  end

  # convert controller input to a graphql input
  # the new input object is sparse based on the params
  def params_to_input(strong_params, params = {}, id_key = nil)
    input = {}

    strong_params.each do |k, v|
      # stringify key
      key = k.to_s

      # convert to integer if integer string
      value = if v.is_a?(String) && v.is_i?
        v.to_i
      elsif v.is_a?(Array) && v[0].is_i?
        v.map(&:to_i)
      else
        v
      end

      input[key] = value
    end

    # add id as an integer with full id_key
    id_key ||= 'id'
    input[id_key] = params[:id].to_i if params[:id].present?

    # add confirm param as proper boolean
    input['confirm'] = params[:confirm] == 'true' if params[:confirm].present?

    # convert boolean params (only GameUpdateScore)
    input['force'] = params[:force] == 'true' if params[:force].present?
    input['resolve'] = params[:resolve] == 'true' if params[:resolve].present?

    input
  end

  def result_to_attributes(result, key, except: nil)
    result[key].deep_transform_keys { |key| key.to_s.underscore }.except(except)
  end

  def result_to_errors(result)
    result['userErrors'] && result['userErrors'].map{ |e| e['field'].capitalize + ' ' + e['message'] }
  end

  def render_admin_404
    respond_to do |format|
      format.html { render 'admin/404', status: :not_found }
      format.any  { head :not_found }
    end
  end
end
