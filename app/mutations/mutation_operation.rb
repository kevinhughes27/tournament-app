class MutationOperation < ActiveOperation::Base
  property :context

  def self.call(object, inputs, context)
    properties = inputs.to_h.map { |k,v| [k.to_sym, v] }.to_h
    super(context: context, **properties)
    {success: true}
  end

  def tournament
    context[:tournament]
  end
end
