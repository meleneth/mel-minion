# frozen_string_literal: true

RSpec.describe Mel::Minion::FileLines do
  let(:subject_name) { "some_name.txt" }
  let(:subject_lines) { [] }
  let(:subject) { Mel::Minion::FileLines.new filename: subject_name, lines: subject_lines }

  describe "basic functionality" do
    it "has lines" do
      expect(subject.lines).to eq([])
    end
  end

  describe "can have lines" do
    let(:subject_lines) { ['gem "some_gem"', 'gem "rails"'] }
    it "has lines" do
      expect(subject.lines).to eq(['gem "some_gem"', 'gem "rails"'])
    end
    describe "#match" do
      it "true case" do
        expect(subject.match "some_gem").to eq(true)
        expect(subject.match "rails").to eq(true)
      end
      it "false case" do
        expect(subject.match "other_gem").to eq(false)
        expect(subject.match "machina").to eq(false)
      end
    end
  end
end
