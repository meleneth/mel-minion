# frozen_string_literal: true

RSpec.describe Mel::Minion::Implement::RubyClass do
  let(:subject) { Mel::Minion::Implement::RubyClass.new "Foo::Bar" }
  let(:project) { instance_double "Mel::Minion::Project", has_lib_dir?: true }

  describe "#module_name" do
    it "works for easy case" do
      expect(subject.module_name).to eq("Foo")
    end
  end
  describe "#class_name" do
    it "works for easy case" do
      expect(subject.class_name).to eq("Bar")
    end
  end
  describe "#file_name" do
    it "works for easy case" do
      allow(Mel::Minion::Project).to receive(:new).and_return project
      expect(subject.file_name).to eq("lib/foo/bar.rb")
    end
  end
  context "Basic Object" do
    let(:subject) { Mel::Minion::Implement::RubyClass.new "Foo" }
    it "exists" do
      subject
    end
    describe "#has_module?" do
      it "works for easy case" do
        allow(Mel::Minion::Project).to receive(:new).and_return project
        expect(subject.has_module?).to eq(false)
      end
    end
    describe "#file_name" do
      it "works for easy case" do
        allow(Mel::Minion::Project).to receive(:new).and_return project
        expect(subject.file_name).to eq("lib/foo.rb")
      end
    end
    describe "#ruby_class" do
      it "works for easy case" do
        expect(subject.ruby_class).to eq "# frozen_string_literal: true

class Foo
end

"
      end
    end
  end
  context "Class in a Module" do
    let(:subject) { Mel::Minion::Implement::RubyClass.new "Foo::Bar" }
    it "exists" do
      subject
    end
    describe "#has_module?" do
      it "works for easy case" do
        allow(Mel::Minion::Project).to receive(:new).and_return project
        expect(subject.has_module?).to eq(true)
      end
    end
    describe "#ruby_class" do
      it "works for easy case" do
        expect(subject.ruby_class).to eq "# frozen_string_literal: true

module Foo
  class Bar
  end
end

"
      end
    end
    describe "#spec_file" do
      it "works for easy case" do
        expect(subject.spec_file).to eq "# frozen_string_literal: true

RSpec.describe Foo::Bar do
  let(:subject) { Foo::Bar.new }
end

"
      end
    end
  end
end
