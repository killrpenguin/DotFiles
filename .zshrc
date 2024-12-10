# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gentoo"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
COMPLETION_WAITING_DOTS="%F{green}waiting...%f"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Plugin stuff including keybindings for history substring search
plugins=(git postgres history-substring-search colorize colored-man-pages)

#colorize plugin
ZSH_COLORIZE_STYLE="colorful"

#History substring search plugin
source $ZSH/oh-my-zsh.sh
source $ZSH/plugins/history-substring-search/history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# User configuration
export COMP_WORDBREAKS=" /\"\'><;|&(" # for cppman completions with :
export LANG=en_US.UTF-8
export PATH="/home/david/bin:$PATH"
export PATH="/home/david/.cargo/bin:$PATH"
export PATH="/home/david/.emacs.d/packages/cask/bin:$PATH"
export PATH="/usr/bin/go:$PATH"
export MANPAGER="emacsclient -t -q"
export RUST_BACKTRACE=1
export RUST_LOG=die_rat="debug"
export GOROOT=/usr/lib/go
export GOPATH=$HOME/Programming/Go

export VULKAN_SDK=/usr/bin/vulkan-sdk-1.3.290.0
export PATH=$VULKAN_SDK/bin:$PATH
export LD_LIBRARY_PATH=$VULKAN_SDK/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export VK_LAYER_PATH=$VULKAN_SDK/share/vulkan/explicit_layer.d

export CXX=/usr/lib/llvm/19/bin/clang++

SAVEHIST=1000  # Save most-recent 1000 lines
HISTSIZE=1000
HISTFILE=~/.zsh_history

setopt appendhistory
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt beep

# Style Settings
zstyle ':completion:*' file-sort type
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select=long
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'

autoload -Uz add-zsh-hook

add-zsh-hook -Uz precmd reset_broken_terminal

# Preferred editor for local and remote sessions.
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
 else
   export EDITOR='nano'
 fi
 
#Fix broken terminal code from arch wiki-zsh.
function reset_broken_terminal () {
      printf '%b' '\e[0m\e(B\e)0\017\e[?5]\e7\e[0;0r\e8'
}

#Use Emacs for man pages.
function macsman() {
    emacsclient -c -e "(let ((Man-notify-method 'bully)) (man \"$1\"))"
}

#Create CMakeLists.txt file with with min_req variable set to current cmake ver.
function make_cmakelist_file(){
    VER=$(cmake --version | grep -o '[[:digit:]].' | tr -d '\n')
    STR="cmake_minimum_required(VERSION "$VER")"
    echo ${STR} > CMakeLists.txt
    echo "Done"
}
 
# Aliases
#shell command modifications
alias ls='ls --color=tty -alh'
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias l='ls --color=tty -I ".*"'
alias cp='cp -i'
alias C='clear'
alias mv='mv -i'
alias ccat='pygmentize -P style=rrt'
alias PIC="kitten icat"
alias cpv="rsync -ah --progress" #copy files with progress information
alias man=macsman
alias R='cd $HOME/Programming/Rust/'
alias CPP='cd $HOME/Programming/cpp_dev'
alias VSDK='cd /usr/bin/vulkan-sdk-1.3.290.0'

#dot files
alias rzshrc='source ~/.zshrc && echo "Done"'
alias rqtile='qtile cmd-obj -o cmd -f reload_config'
alias zshrc=emacs_edit_zshrc

#Gentoo 
alias UPDATE='sudo emaint -a sync && sudo emerge --update --deep --newuse @world'
alias USE='sudo emerge --deep --changed-use @world'
alias PKG='eix-installed -a'
# eix -r '^emacs$'
alias DLS='tail -f /var/log/emerge-fetch.log'

#C++/cmake
alias NEW_CMAKE='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_C_COMPILER=/usr/lib/llvm/19/bin/clang -DCMAKE_CXX_COMPILER=/usr/lib/llvm/19/bin/clang++ -B build'
alias GI='cp /home/david/Documents/Cpp_Docs/cpp.gitignore.template .gitignore'

alias CML=make_cmakelist_file

alias cmake_test='cmake --build build --target test && valgrind --leak-check=full ./build/tests/testlib'
alias cmake_docs='cmake --build build --target docs'
alias cmake_build='cmake --build build'
alias cmake_run='cmake --build build && ./build/main/main'

alias gdb='gdb --tui'
alias vgdb_start='valgrind --tool=memcheck --vgdb=yes --vgdb-error=0'

#Rust
alias CT='cargo test -- --nocapture'
alias rgdb='rust-gdb --tui'
#Python/Build System


#SPHINX -p "Project Name"
alias SPHINX='sphinx-quickstart --no-sep -a "David McFarland" -r "1.0.0" -l en'
alias DQ='SCREEN_SIZE=1024x768 ./scripts/xephyr -c dev-config.py'
alias SP='cd ~/Programming/py/scratch-pad && source venv/bin/activate'
alias LASTUPDATE='tail -n250 /var/log/emerge.log | ag completed'
alias VNV='source venv/bin/activate'
