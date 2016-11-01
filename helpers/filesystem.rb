require 'fileutils'

def rm(list, options = {})
  if list.is_a?(Array)
    list.collect! {|item| item.is_a?(Fancypath) ? item.to_s : item }
  end
  FileUtils.rm list, options
end
def ln_s(src, dest, options = {})
  [src, dest].each do |arg|
    arg = arg.to_s if arg.is_a?(Fancypath)
  end
  FileUtils.ln_s(src, dest, options)
end

class Fancypath
  def directory?
    File.directory?(to_s) && ! symlink?
  end
  def symlink?
    File.symlink?(to_s)
  end
  def symlink_to?(dest)
    symlink? && (readlink == dest.to_fancypath)
  end
end

meta :directory do
  accepts_value_for :target, name

  def target_with_default_home
    if name =~ /^home \w+\.directory$/
      "~" / name.to_s[/^home (\w+)\.directory$/,1]
    else
      target
    end
  end

  template do
    met? do
      target_with_default_home.directory?
    end
    meet do
      mkdir target_with_default_home
    end
  end
end
