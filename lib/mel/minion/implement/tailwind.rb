require "securerandom"
require "fileutils"

module Mel::Minion::Implement
  class Tailwind < Base
    def self.run *args
      hostname = args.shift
      implementor = Tailwind.new hostname

      project = Mel::Minion::Project.new
      raise MustBeInVueProjectError.new unless project.is_vue_project?

      implementor.apply_transform
      implementor.save_modified_files
    end

    def run_command(command)
      # you disgust me
      puts "running: #{command}"
      system(command)
    end

    def apply_transform
      run_command("npm install -D tailwindcss postcss autoprefixer")
      run_command("npx tailwindcss init -p")
      @modified_files << Mel::Minion::FileLines.from_contents(filename: "tailwind.config.js", contents: tailwind_config_js)
      @modified_files << Mel::Minion::FileLines.from_contents(filename: "assets/style.css", contents: style_css)
    end

    def tailwind_config_js
      <<-TEXT
  /** @type {import('tailwindcss').Config} */
  export default {
    content: [
      "./index.html",
      "./src/**/*.{vue,js,ts,jsx,tsx}",
    ],
    theme: {
      extend: {},
    },
    plugins: [],
  }
      TEXT
    end

    def style_css
      <<-TEXT
  @tailwind base;
  @tailwind components;
  @tailwind utilities;
      TEXT
    end
  end
end
