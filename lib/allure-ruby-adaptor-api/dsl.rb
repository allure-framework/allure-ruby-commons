require 'digest'
require 'mimemagic'
module AllureRubyAdaptorApi
  module DSL


    def step(step, &block)
      suite = self.example.metadata[:example_group][:description_args].first
      test = self.example.metadata[:description]
      AllureRSpec::Builder.start_step(suite, test, step)
      __with_step step, &block
      AllureRSpec::Builder.stop_step(suite, test, step)
    end

    def attach_file(title, file, mime_type = nil)
      step = current_step
      dir = Pathname.new(AllureRSpec::Config.output_dir)
      FileUtils.mkdir_p(dir)
      file_extname = File.extname(file.path.downcase)
      mime_type ||= MimeMagic.by_path(file.path) || "text/plain"
      attachment = dir.join("#{Digest::SHA256.file(file.path).hexdigest}-attachment#{(file_extname.empty?) ? '' : file_extname}")
      FileUtils.cp(file.path, attachment)
      suite = self.example.metadata[:example_group][:description_args].first
      test = self.example.metadata[:description]
      AllureRubyAdaptorApi::Builder.add_attachment(suite, test, {
          :type => type,
          :title => title,
          :source => attachment.basename,
          :size => File.stat(attachment).size
      }, step)
    end
  end
end

