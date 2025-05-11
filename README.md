# BetterKali

[Youtube Playlist](https://www.youtube.com/playlist?list=PLS8uf7tTfvJZytyhV3vUZRJ6b9EkNwJ1u)

1. [Kitty](#kitty)
2. [Tmux](#tmux)
3. [OhMyPosh](#ohmyposh)
4. [Others](#others)

<a name="kitty"></a>

## Kitty

```bash
$ sudo apt install kitty
```

Ejecutamos el emulador de terminal.

```bash
$ kitten themes
```

Buscar *Catppuccin-Mocha* con: `Ctrl + /`

Aplicar con: `M`

Podemos añadir un shortcut a kitty.

<a name="tmux"></a>

## Tmux

```bash
$ sudo apt install tmux
```

```bash
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Creamos el archivo: `/home/kali/.config/tmux/tmux.conf`.

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
$ tmux source /home/kali/.config/tmux/tmux.conf
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

`<prefix>` = `Ctrl + SPACE` *(Ctrl + b default)*

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

Aplicamos los cambios anteriores del tema con `<prefix> I`

Añadimos tmux al `.zshrc`.

```bash
if [ "$TMUX" = "" ]; then
  tmux;
fi
```

<a name="ohmyposh"></a>

## OhMyPosh

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

Reinciamos la terminal y vamos a la carpeta de configuración:
`/home/kali/.config/ohmyposh`.

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

<a name="others"></a>

## Others

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
alias findi='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}"'
```

### extractPorts

```bash
$ sudo apt install xclip
```

```bash
# Used: 
# nmap -p- --open -T5 -v -n ip -oG allPorts

# Extract nmap information
# Run as: 
# extractPorts allPorts
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}
```

### mkt

Añadimos los alias al `.zshrc`.

```bash
alias mkt='mkdir {nmap,content,exploits,scripts}'
```