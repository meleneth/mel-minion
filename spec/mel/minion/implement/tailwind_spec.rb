# frozen_string_literal: true

RSpec.describe Mel::Minion::Implement::Tailwind do
  let(:subject) { Mel::Minion::Implement::Tailwind.new }
  let(:project) { instance_double "Mel::Minion::Project", is_vue_project?: true }

  before do
    allow(subject).to receive(:project).and_return(project)
    allow(subject).to receive(:run_command).and_return(true)
  end

  describe "#module_name" do
    it "works for easy case" do
      subject.apply_transform
    end
  end
  describe "must be in a vue project" do
    let(:project) { instance_double "Mel::Minion::Project", is_vue_project?: false }
    before do
      allow(subject).to receive(:project).and_return(project)
      allow(subject).to receive(:run_command).and_return(true)
    end
    it "works for easy case" do
      expect { Mel::Minion::Implement::Tailwind.run }.to raise_error(Mel::Minion::Error::MustBeInVueProjectError)
    end
  end
end
