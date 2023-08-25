# frozen_string_literal: true

RSpec.describe Mel::Minion::Implement::Tailwind do
  let(:subject) { Mel::Minion::Implement::Tailwind.new }
  let(:project) { instance_double "Mel::Minion::Project", is_vue_project?: true }

  before do
    allow(subject).to receive(:project).and_return(project)
  end

  describe "#module_name" do
    it "works for easy case" do
      allow(subject).to receive(:run_command).and_return(true)
      subject.apply_transform
    end
  end
end
