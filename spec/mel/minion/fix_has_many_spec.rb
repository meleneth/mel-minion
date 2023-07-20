# frozen_string_literal: true

RSpec.describe Mel::Minion::FixHasMany do
  let(:subject) { Mel::Minion::FixHasMany.new }
  let(:file1) { Mel::Minion::FileLines.new(filename: "user.rb", lines: ["class User < ApplicationRecord", "", "end"]) }
  let(:file2) { Mel::Minion::FileLines.new(filename: "comment.rb", lines: ["class Comment < ApplicationRecord", "", "end"]) }
  let(:file3) do
    Mel::Minion::FileLines.new(filename: "user_comment.rb",
      lines: [
        "class UserComment < ApplicationRecord",
        "  belongs_to :user",
        "  belongs_to :comment",
        "end"
      ])
  end

  before do
    expect(subject).to receive(:models).and_return([file1, file2, file3])
  end

  describe "#models" do
    it "works for easy case" do
      expect(subject.models).to eq([file1, file2, file3])
    end
  end
  describe "#belongs_to" do
    it "works for easy case" do
      expect(subject.belongs_to[:user]).to eq({})
      expect(subject.belongs_to[:comment]).to eq({})
      expect(subject.belongs_to[:user_comment][:user]).to eq(true)
      expect(subject.belongs_to[:user_comment][:comment]).to eq(true)
    end
  end
end
