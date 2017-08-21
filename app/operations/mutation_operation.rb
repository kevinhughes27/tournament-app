class MutationOperation < ActiveOperation::Base
  property :context

  def self.call(object, inputs, context)
    super(context: context, **inputs.to_h.map { |k,v| [k.to_sym, v] }.to_h)
    {success: true}
  end

  def tournament
    context[:tournament]
  end
end
