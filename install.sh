#!/bin/sh
sudo apt update -y

sudo apt install kitty tmux fzf bat fd-find pyenv xclip ripgrep eza thefuck fastfetch -y

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if ! command -v zoxide 2>&1 >/dev/null
then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    echo 'Zoxide found'
fi

if ! command -v oh-my-posh 2>&1 >/dev/null
then
    curl -s https://ohmyposh.dev/install.sh | bash -s
	oh-my-posh font install CascadiaCode
else
    echo 'OhMyPosh found'
fi

if ! command -v brew 2>&1 >/dev/null
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo 'brew found'
fi

brew install yazi

if ! command -v ~/.pyenv/versions/3.11.11/bin/python 2>&1 >/dev/null
then
	pyenv install 3.11
	pyenv local 3.11
else
	echo 'pyenv 3.11 found'
fi

if ! command -v /opt/py3tools/bin/pip 2>&1 >/dev/null
then
	sudo ~/.pyenv/versions/3.11.11/bin/python -m venv /opt/py3tools

	sudo /opt/py3tools/bin/pip install pwncat-cs
	sudo /opt/py3tools/bin/pip install tldr

	sudo ln -s /opt/py3tools/bin/pwncat-cs /usr/local/bin
	sudo ln -s /opt/py3tools/bin/tldr /usr/local/bin
else
	echo 'py3tools found'
fi

mkdir ~/.config/tmux
mkdir ~/.config/ohmyposh

cat << 'EOF' > ~/.config/tmux/tmux.conf
# Set true color and mouse support
set-option -sa terminal-overrides ",xterm*:Tc"
set -g mouse on

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# Set prefix
unbind C-b
set -g prefix C-space
bind C-space send-prefix

# Open panes in current directory
bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'catppuccin/tmux'

run '~/.tmux/plugins/tpm/tpm'

EOF

cat << 'EOF' > ~/.config/ohmyposh/zen.toml
console_title_template = '{{ .Shell }} in {{ .Folder }}'
version = 3
final_space = true

[[blocks]]
type = 'prompt'
alignment = 'left'
newline = true

[[blocks.segments]]
type = 'path'
style = 'plain'
background = 'transparent'
foreground = 'blue'
template = '{{ .Path }}'

[blocks.segments.properties]
style = 'full'

[[blocks.segments]]
type = 'git'
style = 'plain'
background = 'transparent'
foreground = '#6c6c6c'
template = ' {{ .HEAD }}'

[[blocks]]
type = 'rprompt'
overflow = 'hidden'

[[blocks.segments]]
type = 'executiontime'
style = 'plain'
background = 'transparent'
foreground = 'yellow'
template = '{{ div .Ms 1000 }}s'

[blocks.segments.properties]
threshold = 5000

[[blocks]]
type = 'prompt'
alignment = 'left'
newline = true

[[blocks.segments]]
type = 'text'
style = 'plain'
foreground_templates = [
    "{{if gt .Code 0}}red{{end}}",
    "{{if eq .Code 0}}magenta{{end}}",
]
background = 'transparent'
foreground = 'magenta'
template = ''

[transient_prompt]
foreground_templates = [
    "{{if gt .Code 0}}red{{end}}",
    "{{if eq .Code 0}}magenta{{end}}",
]
background = 'transparent'
foreground = 'magenta'
template = ' '

EOF

cat << 'EOF' > /tmp/extractPorts
#!/bin/bash
# Used:
# nmap -p- --open -T5 -v -n ip -oG allPorts

# Extract nmap information
# Run as:
# extractPorts allPorts

function extractPorts(){
	# say how to usage
	if [ -z "$1" ]; then
		echo "Usage: extractPorts <filename>"
		return 1
	fi

	# Say file not found
	if [ ! -f "$1" ]; then
		echo "File $1 not found"
		return 1
	fi

	#if this not found correctly, you can delete it, from "if" to "fi".
	if ! grep -qE '^[^#].*/open/' "$1"; then
		echo "Format Invalid: Use -oG <file>, in nmap for a correct format."
		return 1
	fi

	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')";
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -selection clipboard
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}
extractPorts "$1"

EOF

chmod +x /tmp/extractPorts
sudo mv /tmp/extractPorts /usr/local/bin/

echo "¿Añadir entradas a .zshrc automáticamente?"
select strictreply in "Yes" "No"; do
    relaxedreply=${strictreply:-$REPLY}
    case $relaxedreply in
        Yes | yes | y ) break;;
        No  | no  | n ) exit;;
    esac
done

while true; do
	read -p "¿Añadir entradas a .zshrc automáticamente? [y/n] " choice
	case "$choice" in
		y|Y|yes ) break;;
		n|N|no ) echo "Saliendo..."; exit 0;;
		* ) echo "Invalid input, please enter y or n";;
	esac
done

cat << 'EOF' >> ~/.zshrc

if [ "$TMUX" = "" ]; then
  tmux;
fi

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

eval "$(zoxide init --cmd cd zsh)"

source <(fzf --zsh)

eval $(thefuck --alias)

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# custom aliases
alias cat='batcat'
alias catn='/bin/cat'
alias catnl='batcat --paging=never'
alias fzfb='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --multi --bind "enter:become(batcat {+})"'
alias fzfe='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --bind "enter:become(nano {}),ctrl-v:become(vim {}),ctrl-c:become(code {}),ctrl-z:become(zed {}),ctrl-e:become(emacs {})"'
alias cdf='cd $(find . -type d -print | fzf --tmux center)'
alias fd='fdfind'
alias mkt='mkdir {nmap,content,exploits,scripts}'
alias ls='eza --icons'
alias l='ls -F'
alias lsn='/bin/ls'

function fzfc() {
  fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --multi --bind "enter:become($1 {+})"
}

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" -- cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd - - "$cwd"
  rm -f -- "$tmp"
}

function zle_fuck_tmux() {
  tmux send-keys "fuck" C-m
}
zle -N zle_fuck_tmux
bindkey '^F' zle_fuck_tmux

fastfetch

EOF

echo "\nTerminado\n"