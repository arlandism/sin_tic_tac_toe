class DefaultStrategy

  def initialize(attr,default,body_to_search)
    @attr = attr
    @default = default
    @body = body_to_search
  end

  def attribute
    value = @body[@attr]
    if value == nil or value == ""
      value = @default
    end
    value 
  end

end
