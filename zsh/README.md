# Configuration for ZSH

## Structure
```
.
├── init.sh     -- RUN THIS FIRST!!  Script to setup zsh based on this repo
├── .zshenv     -- search path, common env variables
├── .zshrc      -- login aliases, functions, options, key bindings, etc.
├── .zlogin     -- sets prompt(?), run external commands at login, e.g. `fortune`
└── README.md
```

## Notes _(reverse chronological order)_
- _2020.10.19_ -- after upgrading to macOS Catalina, zsh became my default shell

# References
- _[rip tutorial on zsh]_ -- A gentle run-down on aspects of zsh
- _[z shell manual]_ -- 'nuff said
- _[zsh startup files]_ -- particularly, how `.zshenv`, `.zshrc`, and `.zlogin` (and, alternatively, `.zprofile`) are loaded
- _[zsh introduction]_ -- highlights of zsh
- _[zsh user guide]_ -- a more complete user guide

[zsh startup files]: http://zsh.sourceforge.net/Intro/intro_3.html
[rip tutorial on zsh]: https://riptutorial.com/zsh
[z shell manual]: http://zsh.sourceforge.net/Doc/
[zsh user guide]: http://zsh.sourceforge.net/Guide/
[zsh introduction]: http://zsh.sourceforge.net/Intro/intro_toc.html