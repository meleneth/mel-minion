# frozen_string_literal: true


# frozen_string_literal: true

RSpec.describe Mel::Minion::RailsProject do
  let(:subject) { Mel::Minion::RailsProject.new }
  let(:user_model_file) do
    Mel::Minion::FileLines.new(
      filename: "user.rb",
      lines: [
        "class User < ApplicationRecord",
        "end"
      ]
    )
  end
  let(:comment_model_file) do
    Mel::Minion::FileLines.new(
      filename: "comment.rb",
      lines: [
        "class Comment < ApplicationRecord",
        "belongs_to :user",
        "end"
      ]
    )
  end
  before do
    expect(subject).to receive(:models).and_return([user_model_file, comment_model_file])
  end
  describe "#belongs_to" do
    it "works for easy case" do
      expect(subject.belongs_to[:user]).to eq({})
      expect(subject.belongs_to[:comment][:user]).to eq(true)
    end
  end

end
