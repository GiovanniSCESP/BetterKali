#!/bin/sh
sudo apt update -y

sudo apt install kitty tmux fzf bat fd-find pyenv xclip -y

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

curl -s https://ohmyposh.dev/install.sh | bash -s

oh-my-posh font install CascadiaCode

pyenv install 3.11

pyenv local 3.11

sudo ~/.pyenv/versions/3.11.11/bin/python -m venv /opt/pwncat

sudo /opt/pwncat/bin/pip install pwncat-cs

sudo ln -s /opt/pwncat/bin/pwncat-cs /usr/local/bin

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

cat << 'EOF' > /usr/local/bin/extractPorts
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
alias fzfe='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --bind "enter:become(nano {}),ctrl-v:become(vim {}),ctrl-c:become(code {}),ctrl-z:become(zed {}),ctrl-e:become(emacs {})"'
alias cdf='cd $(find . -type d -print | fzf --tmux center)'
alias fd='fdfind'
alias mkt='mkdir {nmap,content,exploits,scripts}'

function fzfc() {
  fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --multi --bind "enter:become($1 {+})"
}

EOF
