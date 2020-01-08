export ARCHFLAGS="-arch x86_64"

function network_service_name() {
  SERVICE_GUID="$(printf "open\nget State:/Network/Global/IPv4\nd.show" | \
    /usr/sbin/scutil | /usr/bin/awk '/PrimaryService/{print $3}')"
  SERVICE_NAME="$(printf "open\nget Setup:/Network/Service/${SERVICE_GUID}\nd.show" | \
    /usr/sbin/scutil | /usr/bin/awk -F': ' '/UserDefinedName/{print $2}')"
  echo "${SERVICE_NAME}"
  return 0
}

function sj() {
  killall -9 -m spec.rb
  killall -9 -m webkit
  rake db:test:prepare
  ps aux | grep specjour
  ps aux | grep webkit
  specjour > .specjour.ignore &
  tail -f .specjour.ignore
}

# Hitch
hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'
# Uncomment to persist pair info between terminal instances
# hitch

# Git
function parse_git_branch_with_parens() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function resume() { mvim `git diff --name-only head~$@` ;}

# Setup
export GREP_OPTIONS="--colour --exclude='*.svn-base' --exclude='*.tmp' --exclude='.git*'"
# export PS1="\[\e[1;33m\]\w\[\e[1;30m\]\$(parse_git_branch)\$ \[\e[m\]"
export PS1="\[\e[1;33m\]\w\[\e[m\]\[\e[1;36m\]\$(parse_git_branch_with_parens)\$ \[\e[0m\]"
export PS1="\[\033[G\]$PS1" # always start in the left most column like \r
export PATH="/usr/local/sbin:$PATH"
export MANPATH="/usr/local/man:/opt/local/man:$MANPATH"
export EDITOR="vi"
export HISTIGNORE="fg*"
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=50000
export LSCOLORS="gxfxcxdxbxegedabagacad"
export LESS=FRX
export GOPATH=~/src/go
export GOPRIVATE="github.com/carezone"
# Use proper postgres cluster. Else, migrations add SET LOCK_TIMEOUT = ...; w/e
export PGCLUSTER=9.6/main

# Aliases
#NAVIGATION
alias agg='cd ~/src/go/chimera-aggregator'
alias cm='cd ~/src/campaignmanagementui'
alias gogo='cd ~/src/go'
alias pa='cd ~/src/parliament'
alias pu='cd ~/src/puppet'
alias py='cd ~/src/python-play'
alias src='cd ~/src'
alias restartp='pg_ctl -D /usr/local/var/postgres start'

#"SCRIPTS"
alias fix_skype='rm /Users/katy/Library/Preferences/com.skype.skype.plist'
alias re_db='bundle exec rake db:drop && bundle exec rake db:create && bundle exec rake db:structure:load && bundle exec rake db:migrate && rake db:populate && rake db:test:prepare && echo "Done!"'
alias re_news='rake news:reset && rake news:sources[news_sources.yml,true] && rake news:load[news.csv] && rake news:bing'
alias update_routes='rake routes > /Users/katy/Documents/routes.txt'
#OTHER
alias grep='grep --color=auto'
alias gba='git branch -a'
alias gol='git log --oneline --decorate'
alias gd='git diff -w'
alias la='ls -A'
alias l='ls -CF'
alias ls="ls -G"
alias ll='ls -l'
alias rake="rake --trace"
alias netstat_osx='sudo lsof -iTCP -sTCP:LISTEN -P'
# smooth fonts on external displays, see: http://www.macosxhints.com/article.php?story=20090828224632809
alias smooth_fonts="defaults -currentHost write -globalDomain AppleFontSmoothing -int 2"
alias simpleserver="python -m SimpleHTTPServer"
alias sourcechruby="source /usr/local/share/chruby/chruby.sh"

# Git aliases
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit -v'
alias gca='git commit --amend'
alias gco="git checkout"
alias gd='git diff -w'
alias gdc='git diff --cached' # ****
alias gdh='git diff HEAD'
alias glod='git log --oneline --decorate'
alias gp='git push'
alias gpr='git pull --rebase'
alias grep='grep --color=auto --exclude="*~"'
alias gst='git status' # ****
alias gdo='git diff origin/`parse_git_branch`' # ****
alias gr='git rebase'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias vi='vim'

# Ruby
alias cd_ruby_src="cd $GEM_HOME/../../../"
alias gem_console='irb -I lib -r lib/*.rb'
alias gem_uninstall_all='gem list --no-versions | grep -iE "^\w.*" | xargs gem uninstall -aIx'

# Stardew SMAPI mods
alias smapi='cd ~/Library/Application\ Support/Steam/steamapps/common/Stardew\ Valley/Contents/MacOS/Mods/'

# Tunnel
# $ mkfifo reverse
# $ nc -lp 8080 < reverse | nc localhost 80 > reverse

source `brew --prefix`/etc/bash_completion.d/git-completion.bash

##
# PATH settings
##

# Add GOBIN to path
GOBIN="$GOPATH/bin"
PATH="$GOBIN:$PATH"

# Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"

# Default Ruby, I think. This should probably use RVM instead.
PATH="/usr/local/opt/ruby@2.3/bin:$PATH"
PATH="$PATH:/usr/local/lib/ruby/gems/2.3.0/bin" # Ruby 2.3 gems live here

### Added by the Heroku Toolbelt
PATH="/usr/local/heroku/bin:$PATH"

# Pyenv path
PATH="/Users/katy/.pyenv/versions/3.5.0/bin:$PATH"
eval "$(pyenv init -)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="/Users/katy/.rvm/bin:$PATH"

touch ~/.bashrc_private
source ~/.bashrc_private

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
