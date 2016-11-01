dep 'home' do
  requires 'dotfiles'
  requires 'library symlinks'
end

dep 'dotfiles' do
  requires 'dotfiles.github'

  met? {
    ignore_list = %w[install.rb Rakefile README vendor lib tags]
    Dir.chdir("~/code/dotfiles".p) do
      if (Dir['*'] - ignore_list).all? { |dotfile| ("~/.#{dotfile}").p.exist? }
        log "All required dotfiles accounted for (but not checked for consistency)."
        true
      else
        log "Some or all dotfiles missing."
        false
      end
    end
  }
  meet {
    puts "Failed. Try `rake all` from #{"~/code/dotfiles".p}."
  }
end

dep "dotfiles.github"
dep 'home code.directory'
