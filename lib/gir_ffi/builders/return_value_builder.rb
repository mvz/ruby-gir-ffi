require 'gir_ffi/builders/base_argument_builder'

module GirFFI
  module Builders
    # Implements building post-processing statements for return values.
    class ReturnValueBuilder < BaseArgumentBuilder
      def initialize var_gen, type_info, is_constructor = false, skip = false
        super var_gen, nil, type_info, :return
        @is_constructor = is_constructor
        @skip = skip
      end

      def post
        if has_conversion?
          [ "#{retname} = #{post_conversion}" ]
        else
          []
        end
      end

      def inarg
        nil
      end

      def retval
        if has_conversion?
          super
        elsif is_relevant?
          callarg
        else
          nil
        end
      end

      def is_relevant?
        !is_void_return_value? && !@skip
      end

      private

      def has_conversion?
        is_closure || needs_outgoing_parameter_conversion? || needs_constructor_wrap?
      end

      def post_conversion
        if is_closure
          "GirFFI::ArgHelper::OBJECT_STORE[#{callarg}.address]"
        elsif needs_constructor_wrap?
          "self.constructor_wrap(#{callarg})"
        else
          outgoing_conversion callarg
        end
      end

      def retname
        @retname ||= @var_gen.new_var
      end

      def needs_constructor_wrap?
        @is_constructor && [ :interface, :object ].include?(specialized_type_tag)
      end

      def is_void_return_value?
        specialized_type_tag == :void && !type_info.pointer?
      end
    end
  end
end
