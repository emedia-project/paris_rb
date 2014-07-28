require 'paris' 
require 'sample' ## This come from priv/ruby
extend ErlPort::ErlTerm

def get(_Request)
  if Sample.new.ok? 
    ParisResponse.render(:html, [Tuple.new([:template, :ok])])
  else
    ParisResponse.render(:html, [Tuple.new([:template, :index])])
  end
end

def post(_Request)
  ParisResponse.render(:html, [Tuple.new([:template, :index])])
end

def put(_Request)
  ParisResponse.render(:html, [Tuple.new([:template, :index])])
end

def head(_Request)
  ParisResponse.render(:html, [Tuple.new([:template, :index])])
end

def delete(_Request)
  ParisResponse.render(:html, [Tuple.new([:template, :index])])
end
