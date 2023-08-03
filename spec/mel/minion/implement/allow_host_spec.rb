# frozen_string_literal: true

RSpec.describe Mel::Minion::Implement::AllowHost do
  let(:subject) { Mel::Minion::Implement::AllowHost.new "somehostname.somedomain" }
  let(:project) { instance_double "Mel::Minion::Project", has_lib_dir?: true }
  let(:dev_env_config) do
    Mel::Minion::FileLines.new(
      filename: "app/models/comment.rb",
      lines: [
        "require \"active_support/core_ext/integer/time\"",
        "",
        "Rails.application.configure do",
        "end",
        ""
      ]
    )
  end

  before do
    allow(subject).to receive(:project).and_return(project)
    allow(subject).to receive(:env_file).and_return(dev_env_config)
  end

  describe "#module_name" do
    it "works for easy case" do
      subject.apply_transform
      expect(subject.env_file.lines.count).to eq(6)
      expect(subject.env_file.lines[3]).to eq("  config.hosts << \"somehostname.somedomain\"")
      expect(subject.env_file.lines[4]).to eq("end")
    end
  end
end
