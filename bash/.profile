if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
alias dir='ls -FG'

# Git bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
# Git prompt
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_THEME=Single_line
### NOTE: 2019.07.22 -- Commented this line, as _bash-git-prompt_ is taking very long time (~3sec) to execute for each prompt
[ -f /usr/local/share/gitprompt.sh ] && __GIT_PROMPT_DIR=/usr/local/share && . /usr/local/share/gitprompt.sh
### This is currently the quickest command for Git work
# cf. https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

# Useful aliases/functions
source ~/.git-helpers.sh
alias update_repos='for repodir in $(dir /Users/Shared/Development/NikeBuild/repos); do echo "Updating repo: ${repodir}"; cd ~/repos/$repodir; git fetch origin; git pull origin; done; cd ~/repos'
alias clean_repos='for repodir in $(dir /Users/Shared/Development/NikeBuild/repos); do echo "Clearing node_modules from repo: ${repodir}"; cd ~/repos/$repodir; rm -rf node_modules; done; cd ~/repos'
reset_repos () {
  cd /Users/Shared/Development/NikeBuild/repos
  cwd=$(pwd)
  for repodir in $(ls); do
    echo "Resetting repo: ${repodir}"
    cd $cwd/$repodir
    git add . && git stash push -m "auto-stash $(date -j +"%Y-%m-%d %H:%M:%S %Z")" || continue
    git checkout master || continue
    git fetch origin || continue
    git pull origin master || continue
    cd $pwd
  done
}
alias my_commits='git log --author="Rauha"'
epoch_to_date () { epoch=$(( $1 / 1000 )); date -j -f "%s" "+%F %r" $epoch; }
uniq_grep () { grep -ohRE "$1" $(pwd) | sort | uniq | less; }
my_recent_commits () {
  if [ -z "$1" ]; then echo "Usage: my_recent_commits YYYY-MM-DD"; return 0; fi
  cwd=$(pwd)
  output=~/Desktop/recent-commits-$(date +"%Y%m%d").txt
  echo "Commits since ${1} in checked-out repos as of $(date +"%Y-%m-%d")" > ${output}
  cd ~/repos
  for repo in $(dir); do
    cd ~/repos/${repo}
    tmp=$(my_commits --since="$1")
    if [ -n "$tmp" ]; then
      echo -e "\n============\n$(git config remote.origin.url)\n============\n${tmp}" >> ${output}
    fi
  done
  cd $cwd
}
alias listen_ports='sudo lsof -iTCP -sTCP:LISTEN -n -P'
alias local_ports='netstat -ap tcp | grep -i "listen"'
alias py_test='python -m pytest'
get_nt_email () {
  ldapsearch -x -h ldap.nike.com -b "dc=ad,dc=nike,dc=com" samaccountname=$1 | grep ^mail
}
alias kafdrop='docker run -it -p 9099:9099 -e SERVER_PORT=9099 -e KAFKA_BROKERCONNECT=host.docker.internal:9092 obsidiandynamics/kafdrop:latest'
alias recent_crashes='find /Library/Logs/DiagnosticReports -type f -mtime -1 -print0 | xargs -0 stat -f "%Sm -- %z / %N" -t "%F %R" | sort -r'

# Jenkins2 functions/aliases
jenkins_validate () {
  JENKINS_URL="${1}"
  JENKINS_CRUMB=`curl "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"`
  curl -X POST -H "$JENKINS_CRUMB" -F "jenkinsfile=<$2" "${JENKINS_URL}/pipeline-model-converter/validate"
}
alias pdftk="docker run -v \"$(pwd):/work\" mnuessler/pdftk"

# Jeter aliases
alias jeter_kafkacat='kubectl exec -n jeter kafkacat-jq-7b6949b4d6-qzv84 -- kafkacat '

# Eureka access
eureka_req () {
  ENDPOINT="${1}"
  DOMAIN="${2:-eureka-us-east-1.test.commerce.nikecloud.com}"
  read -p "NT Password: " -s p && curl -s -L -X GET -H "Accept: application/json" "https://${DOMAIN}/eureka/v2/${ENDPOINT#/}" --proxy 'squid.tools.nikecloud.com:3128' -U "$(whoami):$p" | jq -C '.' | less -R
}

# NPM local repository
alias start_npm='docker run --name sinopia -d -p 4873:4873 -v /Users/rrahk1/.sinopia/npm:/sinopia/storage -v /Users/rrahk1/.sinopia/config.yaml:/sinopia/config.yaml rnbwd/sinopia'

# Gradle
alias docker_gradle='docker run --rm -v gradle-cache:/home/gradle/.gradle -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:jdk-alpine gradle -i -s'


###-begin-galen-completions-###
#
# yargs command completion script
#
# Installation: galen completion >> ~/.bashrc
#    or galen completion >> ~/.bash_profile on OSX.
#
_yargs_completions()
{
    local cur_word args type_list

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    args=$(printf "%s " "${COMP_WORDS[@]}")

    # ask yargs to generate completions.
    type_list=`galen --get-yargs-completions $args`

    COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

    # if no match was found, fall back to filename completion
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY=( $(compgen -f -- "${cur_word}" ) )
    fi

    return 0
}
complete -F _yargs_completions galen
###-end-galen-completions-###

### HandBrakeCLI helper function
hb1() {
  OPTIONS=o:i:
  LONGOPTIONS=output:,input:
  PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
  eval set -- "$PARSED"
  while true; do
    case "$1" in
      -i|--input)
        inFile="$2"
        shift 2
        ;;
      -o|--output)
        outFile="$2"
        shift 2
        ;;
      *)
        echo "unrecognized option $1"
        exit 3
        ;;
    esac
  done
  HandBrakeCLI -t 0 -i $inFile -o  $outFile -e x264 -b 1000 -B 192 -s 1 --subtitle-burn
}

### Android SDK
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk

# Terraform w/ automation user
alias tfauto="TF_VAR_aws_profile=automation TF_VAR_db_password=jklsd$^%lk224 TF_VAR_db_username=qmaxtest terraform"


###################################
#
# GraalVM
export PATH="/Applications/GraalVM/Contents/Home/bin:$PATH"

###################################
#
# personal AWS account

alias aws-rrahkola="aws --profile=rrahkola-pu"

###################################
#
# Squid Proxy Tools
export PATH="${PATH}:/Users/rrahk1/repos/squid_toolkit"

###################################
#
# Vulcan Toolkit
export PATH="${PATH}:/Users/rrahk1/repos/cpe_vulcan/build_scripts"

###################################
#
# Baconator Toolkit
export PATH="${PATH}:/Users/rrahk1/repos/baconator/bin"

###################################
#
# Anaconda Python/R distribution
#export PATH="/usr/local/anaconda3/bin:${PATH}"

###################################
#
# Jenv Java environment manager
export PATH="${HOME}/.jenv/bin:${PATH}"

###################################
#
# Practical Gremlin tutorial
alias gremlin="cd ~/repos/practical-gremlin && gremlin/bin/gremlin.sh"
