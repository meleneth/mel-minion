# frozen_string_literal: true

RSpec.describe Mel::Minion::Implement::RailsHasOne do
  let(:subject) { Mel::Minion::Implement::RailsHasOne.new "user", "comment" }
  let(:project) { instance_double "Mel::Minion::RailsProject" }
  let(:user_model_file) do
    Mel::Minion::FileLines.new(
      filename: "app/models/user.rb",
      lines: [
        "class User < ApplicationRecord",
#        "  has_one :comment",
        "end"
      ]
    )
  end
  let(:comment_model_file) do
    Mel::Minion::FileLines.new(
      filename: "app/models/comment.rb",
      lines: [
        "class Comment < ApplicationRecord",
        "  belongs_to :user",
        "end"
      ]
    )
  end

  before do
    allow(project).to receive(:models).and_return([user_model_file, comment_model_file])
    allow(subject).to receive(:project).and_return(project)
  end

  describe "#" do
    it "Works for simple case" do
      subject.do_transform
      expect(subject.modified_files[0].lines[1]).to eq("  has_one :comment")
    end
  end
end
