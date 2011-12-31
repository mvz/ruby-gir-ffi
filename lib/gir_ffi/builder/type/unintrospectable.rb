require 'gir_ffi/builder/type/object'
module GirFFI
  module Builder
    module Type

      # Implements the creation of a class representing an object type for
      # which no data is found in the GIR. Typically, these are created to
      # cast objects returned by a function that returns an interface.
      class Unintrospectable < Object
        CACHE = {}

        # FIXME: Breaks parent interface.
        def initialize gtype
          @gtype = gtype
          @info = nil
        end

        def instantiate_class
          CACHE[@gtype] ||= Class.new(superclass)
          @klass = CACHE[@gtype]
          setup_class unless already_set_up
        end

        def setup_class
          setup_constants
          setup_interfaces
        end

        def setup_instance_method method
          false
        end

        private

        def parent
          parent_type = ::GObject.type_parent @gtype
          gir.find_by_gtype(parent_type)
        end

        def interface_infos
          ::GObject.type_interfaces(@gtype).map do |gtype|
            gir.find_by_gtype gtype
          end
        end

        def interfaces
          interface_infos.map do |info|
            GirFFI::Builder.build_class info
          end
        end

        def signal_definers
          interface_infos
        end

        def gir
          @gir ||= GObjectIntrospection::IRepository.default
        end
      end
    end
  end
end

