module Mongoid::Enum
  extend ActiveSupport::Concern

  module ClassMethods
    def enum(definitions)
      definitions.each(&method(:define_helper_methods))
    end

    def define_helper_methods(name, values)
      singleton_class.send(:define_method, name.to_s.pluralize) { values }
      validates name, inclusion: { in: values.map(&:to_sym) + values.map(&:to_s) + [''] }
      values.each { |value| define_value_helper(name, value) }
    end

    def define_value_helper(name, value)
      scope value, -> { where(name => value) }
      define_method("#{value}?") { self[name].to_s == value.to_s }
      define_method("#{value}!") { update! name => value }
    end
  end
end
