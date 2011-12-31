require File.expand_path('../gir_ffi_test_helper.rb', File.dirname(__FILE__))

describe GirFFI::Builder::Type::Object do
  describe "#find_property" do
    it "finds a property specified on the class itself" do
      builder = GirFFI::Builder::Type::Object.new(
        get_introspection_data('Regress', 'TestObj'))
      prop = builder.find_property("int")
      assert_equal "int", prop.name
    end

    it "finds a property specified on the parent class" do
      builder = GirFFI::Builder::Type::Object.new(
        get_introspection_data('Regress', 'TestSubObj'))
      prop = builder.find_property("int")
      assert_equal "int", prop.name
    end

    it "raises an error if the property is not found" do
      builder = GirFFI::Builder::Type::Object.new(
        get_introspection_data('Regress', 'TestSubObj'))
      assert_raises RuntimeError do
        builder.find_property("this-property-does-not-exist")
      end
    end
  end
end
