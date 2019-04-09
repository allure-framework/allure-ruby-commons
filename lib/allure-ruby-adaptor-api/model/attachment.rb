# frozen_string_literal: true

module AllureRubyAdaptorApi
  class Attachment
    attr_reader :type, :title, :source, :file, :target, :size

    def initialize(type, title, attach_path)
      @type = type
      @title = title
      @source = attach_path.basename
      @file = attach_path.basename
      @target = attach_path.basename
      @size = File.stat(attach_path).size
    end
  end
end
