Title: Using Starship For Terminal Prompt Goodness
Date: 2021-02-27 10:39
Modified: 2021-02-27 10:39
Category: Posts
tags: terminal,starship
cover: static/imgs/default_page_imagev2.jpg
summary: I recently discovered Starship & converted my old prompt to using it.  Lets see what I learned.

Recently I had the good fortune of attending the
[2021 iteration of the Pycascades conference](https://2021.pycascades.com/),
and there was at least one talk that mentioned [Starship](https://starship.rs/)
and at least one other where the presenter happened to be using it.  For those
not in the know, Starship is a cross-shell compatible terminal prompt
generator written in Rust that is super fast and super customizable.

I was intrigued, and decided to take my (reasonably sophisticated) Bash prompt
and Starship-ify it.  In this post I'll outline some of the things I went
through, lessons learned, and hopefully impart some advice on how to do things
with it.

To begin with, here was my old bash prompt:

![My Old Prompt]({static}/static/imgs/oldprompt.png)

That prompt has a bunch of things in it, and shows:

* exit code of the last command (0 in this case)
* the current day & time, along with the TZ info
* the time since I last rebooted (2 days in this case)
* my current directory
* the name of the current branch I’m on (`starship` in this case) and the
  asterisk to indicate there’s uncommitted changes
* The lambda symbol as my input symbol (not a Half-Life reference, more a
  reference to my functional programming days)

Not shown in that screenshot is that when I have a Python virtual environment activated it also gets displayed in the prompt.

The "code" for this that resided in my `.bashrc` file:

```shell
function uptimeinfo {
    uptime | perl -ne 'if(/\d\s+up(.*),\s+\d+\s+users/) { $s = $1; $s =~ s/^\s+|\s+$//g; print $s; }'
}

function proml {
  local        BLACK="\[\033[0;30m\]"
  local         GRAY="\[\033[1;30m\]"
  local          RED="\[\033[0;31m\]"
  local    LIGHT_RED="\[\033[1;31m\]"
  local        GREEN="\[\033[0;32m\]"
  local  LIGHT_GREEN="\[\033[1;32m\]"
  local        BROWN="\[\033[0;33m\]"
  local       YELLOW="\[\033[1;33m\]"
  local         BLUE="\[\033[0;34m\]"
  local   LIGHT_BLUE="\[\033[1;34m\]"
  local       PURPLE="\[\033[0;35m\]"
  local LIGHT_PURPLE="\[\033[1;35m\]"
  local         CYAN="\[\033[0;36m\]"
  local   LIGHT_CYAN="\[\033[1;36m\]"
  local   LIGHT_GRAY="\[\033[0;37m\]"
  local        WHITE="\[\033[1;37m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w \D{%a %b %d %Y %l:%M%p (%Z%z)}\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

PCOLOR="\[\033[\$(promptcol)\]"

# note that in the following prompt the error code item (\$?) must be the
# first item in the prompt.  Otherwise it'll show the errorcode for the last
# command executed in producing the prompt.
PS1="${TITLEBAR}\
$BLUE [$GREEN[\$?] [\D{%a %b %d %Y %l:%M%p (%Z%z)}] [Up: \$(uptimeinfo)] $BROWN\u@\h:\w $LIGHT_GRAY\$(__git_ps1)\
$BLUE]\
\n$PCOLOR λ $LIGHT_GRAY"
PS2='> '
PS4='+ '
}
proml
```

That's a lot, and to be honest, I might be missing some of the code as
[my `.bashrc` file](https://github.com/pzelnip/dotfiles/blob/mainline/dotfiles/.bashrc)
is full of random little snippets.

It's also shell-specific.  If I ever wanted to move to Zsh, or Fish, or whatever, I'd
have to re-invent that (and this has been an impediment for me to switching shells).

So I took this as a starting point and wanted to recreate it in Starship.  Starting
point was to install Starship with Brew:

```shell
brew install starship
```

Easy enough.  Next is to initialize it in your shell of choice.  In my case for
Bash this was adding the following to my `.bashrc`:

```shell
eval "$(starship init bash)"
```

There are equivalent instructions on the
[Starship website](https://starship.rs/) for other prompts

Lastly, you need a `~/.config/starship.toml` file where you'll configure your prompt.

```shell
touch ~/.config/starship.toml
```

Now open up a new terminal and you should see the default Starship prompt
which is actually quite sophisticated out of the box:

![Default Starship Prompt]({static}/static/imgs/defaultstarship.png)

Your output may vary, as many of the items in a Starship prompt are dynamic
depending on your current context.  In this you can see:

* I'm in a directory called `dotfiles`
* I'm currently in a Git repo, but not on any branch instead checked out an
  arbitrary commit with SHA `931e5c4`
* The coffee cup has to do with Java, but I don't have a valid JDK installed so
  it's not showing what version
* My current Python environment is Python 3.9.2
* My AWS environment is configured to communicate with the `ca-central-1` region

That's a lot!  Note that each of those things is what Starship calls a *Module*.
This is one of the key things about Starship is that each part of your prompt is
made up by a distinct module that you configure.  So that prompt is currently
displaying the [Directory Module](https://starship.rs/config/#directory), the
[Git Branch Module](https://starship.rs/config/#git-branch), the
[Git Commit Module](https://starship.rs/config/#git-commit), the
[Python Module](https://starship.rs/config/#python), and the
[AWS Module](https://starship.rs/config/#aws).  Technically it's showing a few
others, but this gives you an idea of how Starship *composes* your prompt by
stringing together some modules.

The full list of all modules can be found at:
[https://starship.rs/config/](https://starship.rs/config/)

Ok, lets get started trying to configure this prompt to be like my old one. I
opened up my `starship.toml` and added the contents from the example on the
Starship docs:

```toml
# Don't print a new line at the start of the prompt
add_newline = false

# Replace the "❯" symbol in the prompt with "➜"
[character]                            # The name of the module we are configuring is "character"
success_symbol = "[➜](bold green)"     # The "success_symbol" segment is being set to "➜" with the color "bold green"

# Disable the package module, hiding it from the prompt completely
[package]
disabled = true
```

With this you probably won't see much change, aside from the symbol changing from
a `>` to a `➜` due to the configuration of the `character` module.  See, everything
in a Starship prompt (including the symbol at the end) is a module.  Well, mostly. 😜

Ok, so it currently shows the directory, but not like my old prompt where A) it was
a yellow-ish colour, and B) showed the full path.  Looking at the docs for the Directory
module, I gave this a try to configure it:

```toml
[directory]
truncation_length = 100
truncate_to_repo = false
style = "yellow"
format = "[:$path]($style)[$read_only]($read_only_style) "
```

Let's explain this a little bit to give a feel:

* `truncation_length` controls how many directories deep you have to be before
  Starship will abbreviate the directory name in your prompt.  I rarely go very
  deep and to be honest when I do I still want to see the full path so I made
  the number rediculously high so that it never truncated
* `truncate_to_repo` is a special setting that controls if the directory is
  truncated to the root of the Git repo you are currently in.  Again, I don't
  like this (I want to see the full path), so deactivated it
* `style` is a common setting on (I believe) every module and controls the
  colour of the module when rendered.  In this case saying "yellow" to match my
  old prompt.  Styles are covered in depth in the
  [docs](https://starship.rs/advanced-config/#style-strings)
* `format` is another common setting across every module and controls
  effectively the "layout" of the module.

It's worth digging into the `format` directive there, as understanding this goes
a long way in understanding how you control Starship's output.  The expression:
`"[:$path]($style)[$read_only]($read_only_style) "` says start a *text group*
(this specified by the `[` and `]` delimiters) and have it output a colon (`:`)
followed by the value of the `$path` variable. Each module has its own set of
variables that get populated with values that are relevant to that module (in
this case `$path` ends up being the full path of the current working directory).
The brackets that follow a text group specify a `style string`.  You might
wonder "but isn't that what the `style` setting is for?"  And yes, but
essentially the `style` setting defines the "default" style within a module, and
style strings within the format can override that.  In this case, `$style`
corresponds to the `style` setting defined in the configuration for the module
(in this case "yellow").  You can see that later in this definition I have the
`$read_only` variable (which gets displayed when the current working directory
is read only) and has a different style defined for that scenario (the default
`$read_only_style` is "red", but you could change that in this configuration by
adding a `read_only_style="blue"` setting to the directory config).  In any case
the relevant part of the docs on format strings is
[here](https://starship.rs/config/#format-strings).

Clear as mud?  Admittedly, this does take a bit to get your head around (or did
for me), but basically you *override* settings in the config as appropriate to
tweak each module to your liking.

Ok, that's fine, but Adam how do we control the order of items in the prompt?
And that's a good question that took me a little while to figure out.  Turns
out that the prompt as a whole has a `format` setting.  The default is to show
all modules, this is from the docs:

```toml
format = "$all"

# Which is equivalent to
format = """
$username\
$hostname\
$shlvl\
$kubernetes\
$directory\
$git_branch\
$git_commit\
$git_state\
$git_status\
$hg_branch\
$docker_context\
$package\
$cmake\
$dart\
$dotnet\
$elixir\
$elm\
$erlang\
$golang\
$helm\
$java\
$julia\
$kotlin\
$nim\
$nodejs\
$ocaml\
$perl\
$php\
$purescript\
$python\
$ruby\
$rust\
$swift\
$terraform\
$vagrant\
$zig\
$nix_shell\
$conda\
$memory_usage\
$aws\
$gcloud\
$openstack\
$env_var\
$crystal\
$custom\
$cmd_duration\
$line_break\
$lua\
$jobs\
$battery\
$time\
$status\
$character"""
```

This is what controls the order of items.  Move an item up, and it'll appear
earlier in the prompt, move down to move it later in the prompt. Personally I
don't like this, as it means if you want to change the order of items you have
to override the *entire* format string.  It'd be nice if there was an "index"
value or something on each module that could determine ordering, but oh well.

In any case it also provides a global "completely hide" ability for a module --
if you remove it from the format then it won't be displayed. Note that I don't
think hiding from the format is the same thing as *disabling* a module.  Each
module has a `disabled` setting which (if true) disables that module (so won't
get displayed, and I believe not evaluated).

Ok, with this I continued on and got most of my old prompt in place:

```toml
# Don't print a new line at the start of the prompt
add_newline = false

[character]
success_symbol = " [λ](grey)"
error_symbol = " [λ](bold red)"

[directory]
truncation_length = 100
truncate_to_repo = false
style = " yellow"
format = "[:$path]($style)[$read_only]($read_only_style) "

[git_branch]
symbol = ""
style = "bold white"
format = '[\($symbol$branch\)]($style) '

[git_status]
# I don't care about untracked files or that there's a stash present.
untracked = ""
format = '([\[$conflicted$deleted$renamed$modified$staged$behind\]]($style) )'
modified = '*'

[status]
disabled = false
format = '[\[$status - $common_meaning\]](green)'
```

This is close, but is missing the current time and "uptime".  And those proved
to be wrinkles for me.  My previous time showed the full current date & time
along with the current timezone info (ex: `PST-0800`).  There's a `time`
module that can recreate all of this *except* the timezone name.  It should,
given the docs on
[format strings for the underlying Chrono library](https://docs.rs/chrono/0.4.7/chrono/format/strftime/index.html),
but turns out there's a
[bug there that causes that to not work](https://github.com/starship/starship/discussions/2360).

But, Starship supports custom commands to be in a module, so I added a custom
command to just defer to the standard `date` command on *-nix type systems:

```toml
[custom.tztime]
command = 'date +"%a %b %d %Y %l:%M%p (%Z%z)"'
when = "true"
format = '[\[$symbol($output)\]](green)'
```

This gives me the time as it was before.  The `when` bit there is `true` so that this
command is *always* displayed.  We'll get to how to control where custom commands
show up in a minute, but there was one more custom command I needed for my system
uptime.  The way I did this in my old prompt was a Bash function:

```shell
function uptimeinfo {
    uptime | perl -ne 'if(/\d\s+up(.*),\s+\d+\s+users/) { $s = $1; $s =~ s/^\s+|\s+$//g; print $s; }'
}
```

And then I used `uptimeinfo` in my prompt.  But that's Bash-specific, so instead I
created a little shell script called `uptime.sh` with the following contents:

```shell
#!/bin/sh

echo "[`uptime | perl -ne 'if(/\d\s+up(.*),\s+\d+\s+users/) { $s = $1; $s =~ s/^\s+|\s+$//g; print $s; }'`]"
```

Which just does the same thing, echoes out the system uptime with it filtered through Perl
to make it more concise.  Now the starship config:

```toml
[custom.uptime]
command = "uptime.sh"
when = "true"
format = "[$symbol($output)](green)"
```

Now back to that layout question: we control the order of things by the global `format`
setting, but how do we refer to custom commands?  Like this:

```toml
format = """
$status \
${custom.tztime} \
${custom.uptime} \
$username\

.... rest of the file ...
```

Ie `${custom.<your custom module name>}`.  Ok with all that, I then had everything I needed,
and continued to flesh out my prompt.  My final config:

```toml
format = """
$status \
${custom.tztime} \
${custom.uptime} \
$username\
$hostname\
$shlvl\
$kubernetes\
$directory\
$git_branch\
$git_commit\
$git_state\
$git_status\
$docker_context\
$package\
$cmake\
$nodejs\
$perl\
$python \
$ruby\
$rust\
$terraform\
$vagrant\
$nix_shell\
$conda\
$aws \
$env_var\
$cmd_duration\
$line_break\
$character"""

# Don't print a new line at the start of the prompt
add_newline = false

[aws]
format = '\[AWS: [$profile/($region)]($style)\]'
symbol = ''
style = 'bold white'

[character]
success_symbol = " [λ](grey)"
error_symbol = " [λ](bold red)"

[cmd_duration]
min_time = 1000

[directory]
truncation_length = 100
truncate_to_repo = false
style = " yellow"
format = "[:$path]($style)[$read_only]($read_only_style) "

[git_branch]
symbol = ""
style = "bold white"
format = '[\($symbol$branch\)]($style) '

[git_status]
# I don't care about untracked files or that there's a stash present.
untracked = ""
format = '([\[$conflicted$deleted$renamed$modified$staged$behind\]]($style) )'
modified = '*'

[python]
format = '[${symbol}${pyenv_prefix}(${version} )(\($virtualenv\))]($style)'

[status]
disabled = false
format = '[\[$status - $common_meaning\]](green)'

[custom.tztime]
command = 'date +"%a %b %d %Y %l:%M%p (%Z%z)"'
when = "true"
format = '[\[$symbol($output)\]](green)'

[custom.uptime]
command = "uptime.sh"
when = "true"
format = "[$symbol($output)](green)"

[env_var]
variable = "0"

#### Disabled modules ####

# add these back to format if you want them:
# $time\
# $hg_branch\
# $dart\
# $dotnet\
# $elixir\
# $elm\
# $erlang\
# $golang\
# $helm\
# $java\
# $julia\
# $kotlin\
# $nim\
# $ocaml\
# $php\
# $purescript\
# $swift\
# $zig\
# $memory_usage\
# $gcloud\
# $openstack\
# $crystal\
# $lua\
# $jobs\
# $battery\
[hg_branch]
disabled = true
[dart]
disabled = true
[dotnet]
disabled = true
[elixir]
disabled = true
[elm]
disabled = true
[erlang]
disabled = true
[golang]
disabled = true
[helm]
disabled = true
[java]
disabled = true
[julia]
disabled = true
[kotlin]
disabled = true
[nim]
disabled = true
[ocaml]
disabled = true
[php]
disabled = true
[purescript]
disabled = true
[swift]
disabled = true
[zig]
disabled = true
[memory_usage]
disabled = true
[gcloud]
disabled = true
[openstack]
disabled = true
[crystal]
disabled = true
[lua]
disabled = true
[jobs]
disabled = true
[battery]
disabled = true

# Until these get resolved, doing my own datetime with date:
# https://github.com/starship/starship/discussions/2360#discussioncomment-391911
# https://github.com/chronotope/chrono/issues/288
[time]
disabled = true
# format = '[\[$time\]](green) '
# time_format = "%a %b %d %Y %l:%M%p (%z)"
```

Note current version (in case I revise in the future) is at:
[https://github.com/pzelnip/dotfiles/blob/mainline/.config/starship.toml](https://github.com/pzelnip/dotfiles/blob/mainline/.config/starship.toml))

This gives a prompt like the following:

![New Starship-Powered Prompt]({static}/static/imgs/newPrompt.png)

Pretty sweet, lots of dynamicism where needed, but still has all the things I
liked from before. Defintely took some time to get this just the way I liked it,
but am happy with the result, and as a bonus: now I have the same prompt if I'm
in Bash, Zsh or whatever.
