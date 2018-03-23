class OnlyFilter
  def self.call(schema_member, context)
    return true unless visibility_proc = schema_member.metadata[:visibility_proc]
    visibility_proc.call(context)
  end
end
