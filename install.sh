sudo apt install kitty

sudo apt install tmux

curl -s https://ohmyposh.dev/install.sh | bash -s

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

sudo apt install fzf

sudo apt install bat

sudo apt install fd-find

mkdir ~/.config/tmux
mkdir ~/.config/ohmyposh

cat << 'EOF' >> ~/.zshrc

if [ "$TMUX" = "" ]; then

  tmux;

fi

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

eval "$(zoxide init --cmd cd zsh)"

source <(fzf --zsh)

# custom aliases
alias cat='batcat'
alias catn='/bin/cat'
alias catnl='batcat --paging=never'
alias fzfb='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --multi --bind "enter:become(batcat {+})"'
alias fzfe='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --bind "enter:become(nano {}),ctrl-v:become(vim >
alias cdf='cd $(find . -type d -print | fzf --tmux center)'
alias mkt='mkdir {nmap,content,exploits,scripts}'
alias fd='fdfind'

function fzfc() {

        fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --multi --bind "enter:become($1 {+})"

}

EOF

