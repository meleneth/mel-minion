# frozen_string_literal: true

require "forwardable"

class Mel::Minion::Mumble
  extend Forwardable

  def_delegator :@gemspec, :save
  def_delegator :@gemspec, :[]
  def_delegator :@gemspec, :[]=
  def_delegator :@gemspec, :index

  attr_reader :gemspec

  def initialize(gemspec)
    raise "Must be gemspec" unless is_gemspec? gemspec
    @gemspec = Mel::Minion::FileLines.from_file filename: gemspec
  end

  def transform
    gemspec[homepage_index] = '  spec.homepage = "http://localhost.localdomain/index.html"' if homepage_index
    gemspec[source_code_uri_index] = '  spec.metadata["source_code_uri"] = "http://localhost.localdomain/project_url"' if source_code_uri_index
    gemspec[changelog_uri_index] = '  spec.metadata["changelog_uri"] = "http://localhost.localdomain/project_url/CHANGELOG.md"' if changelog_uri_index
    gemspec[author_index] = '  spec.authors = ["someuser"]' if author_index
    gemspec[email_index] = '  spec.email = ["someuser@example.org"]' if email_index
    gemspec[description_index] = '  spec.description = "some succinct description"' if description_index
    gemspec[summary_index] = '  spec.summary = "a summary for those that require it - like RubyGems"' if summary_index
  end

  def homepage_index
    index { |l| l =~ /spec.homepage = "TODO/ }
  end

  def source_code_uri_index
    index { |l| l =~ /metadata\["source_code_uri"\] = "TODO/ }
  end

  def changelog_uri_index
    index { |l| l =~ /metadata\["changelog_uri"\] = "TODO/ }
  end

  def author_index
    index { |l| l =~ /authors = \["TODO/ }
  end

  def email_index
    index { |l| l =~ /email = \["TODO/ }
  end

  def description_index
    index { |l| l =~ /description = "TODO/ }
  end

  def summary_index
    index { |l| l =~ /summary = "TODO/ }
  end

  def is_gemspec?(filename)
    filename.end_with? ".gemspec"
  end
end
