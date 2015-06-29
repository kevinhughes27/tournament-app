require 'active_support/concern'

module UpdateSet
  extend ActiveSupport::Concern

  included do
    def self.update_set(set, set_params)
      set_params = force_set_params_to_array(set_params)

      set = delete_unused_models(set, set_params)
      set = update_and_create_models(set, set_params)

      set
    end

    private

    def self.delete_unused_models(set, set_params)
      old_models = set.pluck(:id)
      new_models = set_params.collect{ |m| m[:id].to_i }
      deleted = old_models - new_models
      self.where(id: deleted).destroy_all
      set.reject{ |m| deleted.include? m.id.to_i }
    end

    def self.update_and_create_models(set, set_params)
      set_params.map do |params|
        if params[:id]
          model = set.detect{ |m| m.id == params[:id].to_i }
          model.update_attributes(params)
        else
          model = self.create(params)
          set << model
        end
      end

      set
    end

    def self.force_set_params_to_array(set_params)
      set_params.keys.collect{ |k| set_params[k] } if set_params.is_a?(Hash)
    end

  end
end
