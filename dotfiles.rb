REPOPATH = File.expand_path("~/code/dotfiles")

dep 'dotfiles' do
  requires 'dotfiles repo'
  met? {
    IGNORE_LIST = %w[install.rb Rakefile README vendor lib tags]
    Dir.chdir(REPOPATH) do
      if (Dir['*'] - IGNORE_LIST).all? { |dotfile| File.exist?(File.expand_path("~/.#{dotfile}")) }
        log "All required dotfiles accounted for (but not checked for accuracy)."
        true
      else
        log "Some dotfiles missing."
        false
      end
    end
  }
  meet {
    puts "Failed."
  }
end

dep 'dotfiles repo', :github_user, :repo do
  github_user.default!('matthewfallshaw')
  repo.default!('dotfiles')
  requires 'git'
  met? {
    (REPOPATH / ".git").p.exists?
  }
  meet {
    git "https://github.com/#{github_user}/#{repo}", :to => REPOPATH
    log "You probably want to run install.rb from #{REPOPATH}"
  }
end
