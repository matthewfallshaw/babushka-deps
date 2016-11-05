require 'fileutils'

dep 'notnux' do
  requires 'home'
end

dep 'bootstrap', :github_user, :repo do
  github_user.default!('matthewfallshaw')
  repo.default!('babushka-deps')

  deps_repo = Babushka::WORKING_PREFIX / "deps"
  sources_repo = Babushka::WORKING_PREFIX / "sources/#{github_user}"

  unmeetable!("#{deps_repo} exists but should be a symlink to #{sources_repo}.") if File.directory?(deps_repo.to_s)

  met? do
    Babushka::GitRepo.repo_for(sources_repo).tap {|x| log("#{sources_repo} is not a git repo") unless x } &&
      File.symlink?(deps_repo.to_s).tap {|x| log("#{deps_repo} not a symlink") unless x } &&
      deps_repo.readlink == sources_repo.tap {|x| log("#{deps_repo} is a symlink, but not to #{sources_repo}") unless x }
  end
  meet do
    log "Ensuring git repo at #{sources_repo}."
    git "https://github.com/#{github_user}/#{repo}", :to => sources_repo
    log "Pointing #{deps_repo} at #{sources_repo}."
    FileUtils.ln_s(sources_repo.to_s, deps_repo.to_s, :force => true)
  end
end
