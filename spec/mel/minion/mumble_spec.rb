# frozen_string_literal: true

RSpec.describe Mel::Minion::FileLines do
  let(:subject_name) { "some_name.gemspec" }
  let(:subject) { Mel::Minion::Mumble.new subject_name }
  let(:example_file_lines) { Mel::Minion::FileLines.new filename: subject_name, lines: example_content.split("\n") }

  before do
    allow(Mel::Minion::FileLines).to receive(:from_file).with(filename: subject_name).and_return example_file_lines
  end

  let(:example_content) {
    <<~EXAMPLE
      Gem::Specification.new do |spec|
        spec.name = "mel-scene-fsm"
        spec.version = Mel::Scene::Fsm::VERSION
        spec.authors = ["TODO: Write your name"]
        spec.email = ["TODO: Write your email address"]

        spec.summary = "TODO: Write a short summary, because RubyGems requires one."
        spec.description = "TODO: Write a longer description or delete this line."
        spec.homepage = "TODO: Put your gem's website or public repo URL here."
        spec.required_ruby_version = ">= 2.6.0"

        spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

        spec.metadata["homepage_uri"] = spec.homepage
        spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
        spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

        # Specify which files should be added to the gem when it is released.
        # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
        spec.files = Dir.chdir(__dir__) do
          `git ls-files -z`.split("\x0").reject do |f|
            (File.expand_path(f) == __FILE__) ||
              f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
          end
        end
        spec.bindir = "exe"
        spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
        spec.require_paths = ["lib"]

        # Uncomment to register a new dependency of your gem
        # spec.add_dependency "example-gem", "~> 1.0"

        # For more information and examples about making a new gem, check out our
        # guide at: https://bundler.io/guides/creating_gem.html
      end
    EXAMPLE
  }
  let(:expected) {
    <<~EXAMPLE
      Gem::Specification.new do |spec|
        spec.name = "mel-scene-fsm"
        spec.version = Mel::Scene::Fsm::VERSION
        spec.authors = ["TODO: Write your name"]
        spec.email = ["TODO: Write your email address"]

        spec.summary = "TODO: Write a short summary, because RubyGems requires one."
        spec.description = "TODO: Write a longer description or delete this line."
        spec.homepage = "http://localhost/index.html"
        spec.required_ruby_version = ">= 2.6.0"

        spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

        spec.metadata["homepage_uri"] = spec.homepage
        spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
        spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

        # Specify which files should be added to the gem when it is released.
        # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
        spec.files = Dir.chdir(__dir__) do
          `git ls-files -z`.split("\x0").reject do |f|
            (File.expand_path(f) == __FILE__) ||
              f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
          end
        end
        spec.bindir = "exe"
        spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
        spec.require_paths = ["lib"]

        # Uncomment to register a new dependency of your gem
        # spec.add_dependency "example-gem", "~> 1.0"

        # For more information and examples about making a new gem, check out our
        # guide at: https://bundler.io/guides/creating_gem.html
      end
    EXAMPLE
  }

#      metadata['homepage_uri'] has invalid link: "TODO: Put your gem's website or public repo URL here."

  describe "#homepage_index" do
    it "finds the right index" do
      expect(subject.homepage_index).to eq(8)
    end
  end
  describe "#transform" do
    it "Changes the homepage from the default" do
      subject.transform
      expect(subject.gemspec[8]).to eq('  spec.homepage = "http://localhost/index.html"')
    end
  end
end
