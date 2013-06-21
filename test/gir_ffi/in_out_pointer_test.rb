require 'gir_ffi_test_helper'

require 'gir_ffi/in_out_pointer'

describe GirFFI::InOutPointer do
  describe "an instance created with .from" do
    before do
      @result = GirFFI::InOutPointer.from :gint32, 23
    end

    it "holds a pointer to the given value" do
      assert_equal 23, @result.get_int32(0)
    end

    it "is an instance of GirFFI::InOutPointer" do
      assert_instance_of GirFFI::InOutPointer, @result
    end
  end

  describe ".from" do
    it "handles :gboolean" do
      GirFFI::InOutPointer.from :gboolean, false
    end

    it "handles :utf8 pointers" do
      str_ptr = GirFFI::InPointer.from :utf8, "Hello"
      GirFFI::InOutPointer.from :utf8, str_ptr
    end
  end

  describe "in instance created with .for" do
    before do
      @result = GirFFI::InOutPointer.for :gint32
    end

    it "holds a pointer to a null value" do
      assert_equal 0, @result.get_int32(0)
    end

    it "is an instance of GirFFI::InOutPointer" do
      assert_instance_of GirFFI::InOutPointer, @result
    end
  end

  describe "::for" do
    it "handles :gboolean" do
      GirFFI::InOutPointer.for :gboolean
    end

    it "handles :utf8" do
      GirFFI::InOutPointer.for :utf8
    end
  end

  describe "#to_value" do
    it "returns the held value" do
      ptr = GirFFI::InOutPointer.from :gint32, 123
      assert_equal 123, ptr.to_value
    end

    describe "for :gboolean values" do
      it "works when the value is false" do
        ptr = GirFFI::InOutPointer.from :gboolean, false
        assert_equal false, ptr.to_value
      end

      it "works when the value is true" do
        ptr = GirFFI::InOutPointer.from :gboolean, true
        assert_equal true, ptr.to_value
      end
    end

    describe "for :utf8 values" do
      it "returns a pointer to the held value" do
        str_ptr = GirFFI::InPointer.from :utf8, "Some value"
        ptr = GirFFI::InOutPointer.from :utf8, str_ptr
        assert_equal "Some value", ptr.to_value.read_string
      end
    end
  end
end
