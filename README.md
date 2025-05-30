# BetterKali

![image](https://github.com/user-attachments/assets/679e8f0b-6fad-40a3-8041-7da74b46fa40)


[Youtube Playlist](https://www.youtube.com/playlist?list=PLS8uf7tTfvJZytyhV3vUZRJ6b9EkNwJ1u)

# Instalación Automática
```bash
$ curl https://raw.githubusercontent.com/GiovanniSCESP/BetterKali/refs/heads/main/install.sh | sh
```

Iniciar kitty.

```bash
$ kitty
```

Salir de tmux y entrar a los temas de kitty.

```bash
$ exit
```

```bash
$ kitten themes
```

Buscar *Catppuccin-Mocha* con: `/`

Aplicar con: `M`

Podemos añadir un shortcut a kitty.

Añadimos el source de Tmux.

```bash
$ tmux
```

```bash
$ tmux source ~/.config/tmux/tmux.conf
```

Aplicamos los cambios de tmux con `<prefix> I`.

`<prefix>` = `Ctrl + SPACE` *(Ctrl + b por defecto)*

Reiniciar la terminal y el sistema.

# Instalación Manual

1. [Kitty](#kitty)
2. [Tmux](#tmux)
3. [OhMyPosh](#ohmyposh)
4. [Otros](#otros)
5. [zshrc](#zshrc)

<a name="kitty"></a>

## **Kitty**

Emulador de terminal personalizable y con utilidades.

Instalación:
```bash
$ sudo apt install kitty
```

Ejecutamos el emulador de terminal y entramos al selector de temas.

*No podemos estar en tmux al ejecutar kitten themes*

```bash
$ kitty
```

```bash
$ kitten themes
```

Buscar *Catppuccin-Mocha* con: `/`

Aplicar con: `M`

<a name="tmux"></a>

## **Tmux**
Multiplexor de terminal personalizable.

Instalación:
```bash
$ sudo apt install tmux
```

```bash
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Creamos el archivo: `~/.config/tmux/tmux.conf`.

```
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
```

```bash
$ tmux source ~/.config/tmux/tmux.conf
```

Comandos:

Ver todas las sesiones.
```bash
$ tmux list-sessions
```

Cerrar todas la sesiones o poner un índice.
```bash
$ tmux kill-session -a
```

---

Controles:

`<prefix>` = `Ctrl + SPACE` *(Ctrl + b por defecto)*

Nueva ventana: `<prefix> c`

Cambiar ventana: `<prefix> 0`,1... `<prefix> n` `<prefix> p`

Cerrar ventana: `exit` `<prefix> &`

Renombrar ventana: `<prefix> ,`

Mover Ventana: `<prefix> .`

Pane horizontal: `<prefix> %`

Pane vertical: `<prefix> "`

Cerrar pane: `<prefix> x`

Cambiar pane: `<prefix> FLECHA` `<prefix> q`

Sustituir pane `<prefix> {` `<prefix> }`

Zoom pane: `<prefix> z`

Pane a ventana: `<prefix> !`

---

Aplicamos los cambios anteriores de los plugins con `<prefix> I`

Añadimos tmux al `.zshrc`.

```bash
if [ "$TMUX" = "" ]; then
  tmux;
fi
```

<a name="ohmyposh"></a>

## **OhMyPosh**

```bash
$ curl -s https://ohmyposh.dev/install.sh | bash -s
```

```bash
$ oh-my-posh font install
```

Configurar la fuente en *Appearance*.

Añadimos ohmyposh al `.zshrc`.

```bash
eval "$(oh-my-posh init zsh)"
```

Reinciamos la terminal y vamos a la carpeta de configuración: `~/.config/ohmyposh`.

Exportamos el archivo de configuración backup.
```bash
$ oh-my-posh config export --output ./base.json
```

Exportamos el archivo de configuración toml.
```bash
$ oh-my-posh config export --format toml --output ./zen.toml
```

Modificamos la línea del `.zshrc`.
```bash
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
```

Modificamos el archivo de configuración creado `zen.toml`.

- *Nota1: en `template = '>'` y `template = '> '` el espacio es intencional*.
- *Nota2: Cambiar el símbolo `>` por (angle right), copiando el icon de [nerdfonts](https://www.nerdfonts.com/cheat-sheet).*

``` toml
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
template = '>'

[transient_prompt]
foreground_templates = [
    "{{if gt .Code 0}}red{{end}}",
    "{{if eq .Code 0}}magenta{{end}}",
]
background = 'transparent'
foreground = 'magenta'
template = '> '
```

<a name="otros"></a>

## Otros

### Zoxide

```bash
$ curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

Añadimos Zoxide al `.zshrc`.
```bash
eval "$(zoxide init --cmd cd zsh)"
```

Comandos adicionales:
```bash
$ zoxide edit
```


### Fuzzy Finding + Zoxide

```bash
$ sudo apt install fzf
```

Añadimos fzf al `.zshrc`.

```bash
source <(fzf --zsh)
```

- `Ctrl + R`: Abre una ventana de buscador del historial, con enter escribe el comando en la terminal.
- `Ctrl + T`: Abre una ventana de buscador de archivos, con enter escribe la ruta.
- `Ctrl + C`: Abre una ventana de buscador de directorios, con enter hace un cd a la ruta.

Ahora podemos hacer uso del comando de Zoxide `cdi` para un menú interactivo de búsquedas frecuentes.

### Batcat + Fuzzy Finding

```bash
$ sudo apt install bat
```

Añadimos los alias al `.zshrc`.

```bash
alias cat='batcat'
alias catn='/bin/cat'
alias catnl='batcat --paging=never'
alias fzfb='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --multi --bind "enter:become(batcat {+})"'
alias fzfe='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --bind "enter:become(nano {}),ctrl-v:become(vim {}),ctrl-c:become(code {}),ctrl-z:become(zed {}),ctrl-e:become(emacs {})"'
alias cdf='cd $(find . -type d -print | fzf --tmux center)'

function fzfc() {
	fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" --multi --bind "enter:become($1 {+})"
}
```

- `cat`: Se ejecuta batcat en su lugar.
- `catn`: Se ejecuta el /bin/cat normal.
- `catnl`: Se ejecuta batcat sin la función more.
- `fzfb`: Buscador de archivos, abre el contenido con batcat.
- `fzfe`: Buscador de archivos para edición abre el contenido en un editor:
  - `ENTER`: nano
  - `Ctrl + E`: emacs
  - `Ctrl + Z`: zed
  - `Ctrl + C`: code
  - `Ctrl + V`: vim
- `fzfc`: Buscador de archivos, ejecuta el comando que se escriba al archivo seleccionado:
  - E.g. `fzfc code`

### fd-find

```bash
$ sudo apt install fd-find
```

Añadimos los alias al `.zshrc`.

```bash
alias fd='fdfind'
```
Podemos juntarlo con fzf.

```bash
$ fd passwd /etc | fzfb
```

### pwncat

```bash
$ sudo apt install pyenv
```


```bash
$ pyenv install 3.11
```

```bash
$ pyenv local 3.11
```

```bash
$ sudo ~/.pyenv/versions/3.11.11/bin/python -m venv /opt/pwncat
```

```bash
$ sudo /opt/pwncat/bin/pip install pwncat-cs
```

```bash
$ sudo ln -s /opt/pwncat/bin/pwncat-cs /usr/local/bin
```

https://pwncat.readthedocs.io/en/latest/

### extractPorts

```bash
$ sudo apt install xclip
```

```bash
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
```

Añadirlo a una ruta del $PATH E.g. `/usr/local/bin/extractPorts` y darle permisos de ejecución con `chmod +x`.

### mkt

Añadimos los alias al `.zshrc`.

```bash
alias mkt='mkdir {nmap,content,exploits,scripts}'
```

<a name="zshrc"></a>

## zshrc

Archivo -zshrc completo.

```bash
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
```

## Errores
En las nuevas versiones de kali puede dar un error al autocompletar luego de un upgrade.

https://forums.kali.org/t/bug-in-new-kali-upgrade/6423

Se puede solucionar con:
```bash
$ sudo activate-global-python-argcomplete
```
