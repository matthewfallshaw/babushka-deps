dep 'library symlinks' do
  requires 'library utils symlinks'
end

dep 'library utils symlinks' do
  requires 'library scripts.symlink'
end

dep "library scripts.symlink" do
  requires "code utils.github"
  
  source "~/code/utils/Scripts"
  dest "~/Library/Scripts"
end

dep 'code utils.github' do
  requires 'home code.directory'

  repo "utilities"
  local_path "~/code/utils"
end
