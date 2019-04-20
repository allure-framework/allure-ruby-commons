# frozen_string_literal: true

require "open-uri"
require "zip"
require "pathname"

module Allure
  DOWNLOAD_URL = "http://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/"\
  "#{Version::ALLURE}/allure-commandline-#{Version::ALLURE}.zip"

  class << self
    def allure_bin
      return "allure" if Version::ALLURE == `allure --version`.chomp

      cli_dir = File.join(".allure", "allure-#{Version::ALLURE}")
      zip = File.join(".allure", "allure.zip")
      bin = File.join(cli_dir, "bin/allure")

      FileUtils.mkpath(".allure")
      download_allure(zip) unless File.exist?(zip) || File.exist?(bin)
      extract_allure(zip, ".allure") unless File.exist?(bin)

      bin
    end

    private

    def download_allure(destination)
      File.open(destination, "w") { |file| file.write(open(DOWNLOAD_URL).read) } # rubocop:disable Security/Open
    end

    def extract_allure(zip, destination)
      Zip::File.foreach(zip) do |entry|
        entry.restore_permissions = true
        entry.extract(File.join(destination, entry.name))
      end
      FileUtils.rm(zip)
    end
  end
end
