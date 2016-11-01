require 'fileutils'

def ln_s(src, dest, options = {})
  [src, dest].each do |arg|
    arg = arg.to_s if arg.is_a?(Fancypath)
  end
  FileUtils.ln_s(src, dest, options)
end
