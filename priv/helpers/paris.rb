def underscore(camel_cased_word)
  camel_cased_word.to_s.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
end

def Object.const_missing(name)
  @defined_classes ||= []

  module_sym = underscore(name.to_s).to_sym

  if @defined_classes.include?(name)
    self.class.const_get(name.to_sym)
  else
    @defined_classes << name
    self.class.const_set(name.to_sym, Class.new)
    self.class.const_get(name.to_sym).module_eval(%Q{
      def self.method_missing(method, *args)
        method_sym = method.id2name.to_sym
        module_sym = #{module_sym.inspect}

        ErlPort::Erlang.call(module_sym, method_sym, args)
      end
    })
    self.class.const_get(name.to_sym)
  end
end

