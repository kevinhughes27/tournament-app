Number::ordinal = ->
  return 'th' if 11 <= this % 100 <= 13
  switch this % 10
    when 1 then 'st'
    when 2 then 'nd'
    when 3 then 'rd'
    else        'th'

Number::ordinalize = ->
  this + this.ordinal()
