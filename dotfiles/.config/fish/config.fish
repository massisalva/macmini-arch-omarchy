# Fish interactivo para el escritorio; los scripts del proyecto siguen usando Bash.
if not status is-interactive
    exit
end

set -g fish_greeting

set -gx EDITOR vim
set -gx VISUAL vim
set -gx BAT_THEME ansi

set -gx FZF_DEFAULT_OPTS \
    '--color=bg+:#32344a,bg:#1a1b26,spinner:#7dcfff,hl:#7aa2f7' \
    '--color=fg:#a9b1d6,header:#bb9af7,info:#e0af68,pointer:#7dcfff' \
    '--color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7aa2f7,border:#32344a' \
    '--border=rounded --height=45% --layout=reverse'

if type -q fzf
    fzf --fish | source
end

if type -q zoxide
    zoxide init fish | source
end

# Tokyo Night, en sintonía con Foot, Fuzzel y Waybar.
set -g fish_color_normal a9b1d6
set -g fish_color_command 7aa2f7
set -g fish_color_keyword bb9af7
set -g fish_color_quote 9ece6a
set -g fish_color_redirection 7dcfff
set -g fish_color_end e0af68
set -g fish_color_error f7768e
set -g fish_color_param c0caf5
set -g fish_color_comment 565f89
set -g fish_color_selection --background=32344a
set -g fish_pager_color_prefix 7aa2f7
set -g fish_pager_color_selected_background --background=32344a

abbr --add -- gs 'git status --short --branch'
abbr --add -- ga 'git add'
abbr --add -- gc 'git commit'
abbr --add -- gp 'git push'
abbr --add -- ll 'ls -lah'
abbr --add -- ff 'fastfetch'
abbr --add -- bt 'bat'
abbr --add -- lt 'eza --tree --level=2 --group-directories-first --icons=auto'

function fish_prompt
    set -l last_status $status
    set_color 9ece6a
    printf '[%s' $USER
    set_color 565f89
    printf '@'
    set_color bb9af7
    printf '%s ' (prompt_hostname)
    set_color 7aa2f7
    printf '%s' (prompt_pwd)
    set_color 9ece6a
    printf ']'
    if test $last_status -ne 0
        set_color f7768e
        printf ' [%s]' $last_status
    end
    set_color 7dcfff
    printf ' ❯ '
    set_color normal
end
