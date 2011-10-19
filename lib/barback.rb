require "barback/version"

module Barback
  extend ActiveSupport::Concern

  module InstanceMethods
    def pod_template
      self.class.name.demodulize.underscore
    end
  end

  module ClassMethods
    def handlebars_object(path = nil, opts={}, &block)
      path = name.underscore unless path.is_a?(String) or path.blank?
      new.tap do |instance|
        define_json_serializer_methods_on(instance, path)
        define_association_methods_on(instance) if self.respond_to? :reflect_on_all_associations
        define_schema_methods_on(instance, path) if self.respond_to? :schema
        define_special_methods_on(instance, path) if self.respond_to? :handlebars_methods
        define_generic_methods_on(instance, path, opts)
        instance.class_eval(&block) if block_given?
      end
    end

    def handlebars_collection(iterator = nil)
      [handlebars_object("this", :iterator => iterator)]
    end

    protected

    def define_special_methods_on(instance, path)
      instance.class_eval do
        instance.class.handlebars_methods.each do |method|
          define_method(method) do
            HandlebarsString.new(%Q|{{#{path ? "#{path}.#{method}" : method.to_s}}}|)
          end
        end
      end
    end

    def define_generic_methods_on(instance, path, opts={})
      instance.class_eval do
        define_method(:handlebars?) do
          true
        end

        define_method(:to_param) do
          HandlebarsString.new(%Q|{{#{path ? "#{path}.to_param" : "to_param"}}}|)
        end

        define_method(:naked) do
          HandlebarsString.new(path || instance.class.name.underscore)
        end

        define_method(:iterator) do
          HandlebarsString.new(opts[:iterator] || instance.class.name.underscore.pluralize)
        end
      end
    end

    def define_json_serializer_methods_on(instance, path)
      json_hash = instance.as_json
      if instance.class.include_root_in_json? and json_hash.length == 1
        json_hash = json_hash[instance.class.name.demodulize.underscore]
      end
      json_hash.keys.each do |key|
        instance.class_eval do
          define_method(key) do
            if json_hash[key].nil?
              HandlebarsString.new(%Q|{{#{path ? "#{path}.#{key}" : key}}}|)
            end
          end
        end
      end
    end

    def define_schema_methods_on(instance, path)
      json_hash = instance.schema.as_json
      json_hash.keys.each do |key|
        instance.class_eval do
          define_method(key) do
            HandlebarsString.new(%Q|{{#{path ? "#{path}.#{key}" : key}}}|)
          end
        end
      end
    end

    def define_association_methods_on(instance)
      instance.class.reflect_on_all_associations.each do |association|
        instance.class_eval do
          define_method(association.name) do
            klass = association.options[:class_name] || association.name.to_s.classify
            begin
              if association.instance_variable_get(:@collection)
                klass.constantize.handlebars_collection
              else
                # create hbars object from class, but name it according to the association name (for relations that specify a :source etc)
                klass.constantize.handlebars_object(association.name.to_s.classify.underscore || klass.underscore)
              end
            rescue NoMethodError
              nil
            end
          end
        end
      end
    end
  end
end

class ActiveRecord::Base
  include Barback
end

class ActiveResource::Base
  include Barback
end
