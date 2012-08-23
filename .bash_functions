function calc(){
    python -c "print $*"
}

function rmpyc(){
    find . -name "*.pyc" -exec rm -rfv {} \;
}

function is_in(){
    grep $1 <<< $2 > /dev/null 2>&1 && return 0 || return 1
}

function gvim(){
    /usr/bin/gvim -f $* &
}

function gitbranch(){
    # Show current branch on a git directory
    if git branch > /dev/null 2>&1; then
        echo -e "($(git branch 2> /dev/null | grep "^*" | sed "s/^* //")) "
    fi
}

function stripy(){
    # Remove spaces from end of lines
    if [ $# -gt 1 ]; then
        files=$(find . -name "$1" | xargs file | grep text[^:]*$ | sed 's/:[^:]\+$//')
        echo "1"
    else
        files=$(find . | xargs file | grep text[^:]*$ | sed 's/:[^:]\+$//')
        echo "2"
    fi

    for file_ in $files; do
        echo $file_
        sed -i 's/[[:space:]]\+$//' $file_
    done
}

function sysname(){
    # Show Ubuntu version
    codename="$(grep 'DISTRIB_CODENAME' /etc/lsb-release | sed 's/^[^=]\+=//')"

    if [[ $1 =~ ^(-a|--all)$ ]]; then
        description="$(grep 'DISTRIB_DESCRIPTION' /etc/lsb-release | sed 's/^[^=]\+=//;s/"//g')"
        echo "$description $codename"
    else
        echo "$codename"
    fi
}
