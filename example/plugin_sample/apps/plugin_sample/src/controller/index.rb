require 'paris' 
require 'sample' ## This come from priv/ruby

def get(_Request)
  if Sample.new.ok? 
    ParisResponse.render_view(:ok)
  else
    ParisResponse.render_view(:index)
  end
end

def post(_Request)
  ParisResponse.render_view(:index)
end

def put(_Request)
  ParisResponse.render_view(:index)
end

def head(_Request)
  ParisResponse.render_view(:index)
end

def delete(_Request)
  ParisResponse.render_view(:index)
end
