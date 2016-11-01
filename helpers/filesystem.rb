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

meta :github do
  accepts_value_for :github_user, "matthewfallshaw"
  accepts_value_for :repo, :basename
  accepts_value_for :local_path

  template do
    met? {
      xlocal_path = local_path ? local_path : "~/code" / repo
      Babushka::GitRepo.repo_for(xlocal_path.p)
    }
    meet {
      xlocal_path = local_path ? local_path : "~/code" / repo
      git "https://github.com/#{github_user}/#{repo}", :to => xlocal_path.p
    }
  end
end

meta :symlink do
  accepts_value_for :source
  accepts_value_for :dest

  template do
    setup do
      if dest.p.directory? && ! dest.p.empty?
        unmeetable! "#{dest} exists. Remove it so I can replace it with a link to #{source}."
      end
    end
    met? { dest.p.symlink_to?(source.p) }
    meet do
      rm dest if dest.exist?
      ln_s source, dest  #, :force => true
    end
  end
end
