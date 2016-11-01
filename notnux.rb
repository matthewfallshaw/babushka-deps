dep 'notnux' do
  requires 'home'
  requires 'GitX.app'
end

dep 'bootstrap', :github_user, :repo do
  github_user.default!('matthewfallshaw')
  repo.default!('babushka-deps')

  met? do
    Babushka::GitRepo.repo_for(Babushka::WORKING_PREFIX / "sources/#{github_user}") &&
      (Babushka::WORKING_PREFIX / "deps").symlink_to?(Babushka::WORKING_PREFIX / "sources/#{github_user}")
  end
  meet do
    git "https://github.com/#{github_user}/#{repo}", :to => Babushka::WORKING_PREFIX / "sources/#{github_user}"
    ln_s Babushka::WORKING_PREFIX / "sources/#{github_user}", Babushka::WORKING_PREFIX / "deps", :force => true
  end
end
