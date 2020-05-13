function mkcd {
    mkdir -p $1 && cd $1
}

function rmpyc {
    find . -name "*.pyc" -delete;
}

function __git_rm {
    git rm $* 2> /dev/null || trash $*
}

function __git_mv {
    MV=$(which mv)
    git mv $* 2> /dev/null || $MV $*
}

function remove_trailing_spaces {
    find . -regex '.*\.py\|.*\.php\|.*\.js\|.*\.c\|.*\.cpp\|\|.*\.sh.*\.html' |\
        xargs sed -i 's/[[:space:]]\+$//'
}

function format_js {
    find -regex ".*\.\(js\|json\|css\|html\)" \
    	-not -path "./bower_components/*" \
    	-not -path "./node_modules/*" \
    	-not -path "./dist/*" \
    	-not -path "./.publish/*" \
   	 -not -path "./.tmp/*" \
    	| xargs js-beautify --quiet --replace
}

function update_fonts {
    find ~/Dropbox/fonts -regex '.*\.ttf\|.*\.otf' -exec cp '{}' ~/.local/share/fonts/ \;
}

function add_hook_venv {
    echo "cd $PWD" > $VIRTUAL_ENV/bin/postactivate
}

function sysname {
    # Show Ubuntu version
    codename="$(grep 'DISTRIB_CODENAME' /etc/lsb-release | sed 's/^[^=]\+=//')"

    if [[ $1 =~ ^(-a|--all)$ ]]; then
        description="$(grep 'DISTRIB_DESCRIPTION' /etc/lsb-release | sed 's/^[^=]\+=//;s/\"//g')"
        echo "$description $codename"
    else
        echo "$codename"
    fi
}

# Programming contests training helpers

function new-problem {
    if [ -z $1 ]; then
        echo "You should inform a problem ID."
        return 1
    fi

    if [ -z $2 ]; then
        echo "You should inform a language."
        return 1
    fi

    dir=$1
    language=$2

    if [ -d $dir ]; then
        echo "Already there is a folder called $dir."
        return 1
    fi

    mkcd $dir && echo "Created $dir."

    touch in.txt
    touch out.txt
    touch problem.txt
    touch $dir.$language
}

function marathon {

    # function to run tests in programming contest folders

    function clean {
            find . -regex '.*\.\(py[co]\|out\)$' -delete
            find . -name 'out2.txt' -delete
    }

    function _test {
        test -f out2.txt && echo "$1" && diff out.txt out2.txt && echo ' - OK'
    }

    if [ -f 'in.txt' -a -f 'out.txt' ]; then
        if [ -f *.c ]; then
            gcc -Wall *.c -lm && ./a.out < in.txt > out2.txt
            _test 'C code: '
            clean
        fi

        if [ -f *.cpp ]; then
            g++ -Wall *.cpp -lm && ./a.out < in.txt > out2.txt
            _test 'C++ code: '
            clean
        fi

        if [ -f *.py ]; then
            python *.py < in.txt > out2.txt
            _test 'Python code: '
            clean
        fi

        if [ -f *.js ]; then
            node *.js < in.txt > out2.txt
            _test 'Javascript code: '
            clean
        fi

    elif [ -f 'out.txt' ]; then
        if [ -f *.c ]; then
            gcc -Wall *.c -lm && ./a.out > out2.txt
            _test 'C code: '
            clean
        fi

        if [ -f *.cpp ]; then
            g++ -Wall *.cpp -lm && ./a.out > out2.txt
            _test 'C++ code: '
            clean
        fi

        if [ -f *.py ]; then
            python *.py > out2.txt
            _test 'Python code: '
            clean
        fi

        if [ -f *.js ]; then
            node *.js > out2.txt
            _test 'Javascript code: '
            clean
        fi
    fi
}

#.# Better Git Logs.
### Using EMOJI-LOG (https://github.com/ahmadawais/Emoji-Log).

# Git Commit, Add all and Push — in one step.
# function gcap() {
#     git add . && git commit -m "$*" && git push
# }

function gcap() {
    git commit -m "$*"
}

# NEW.
function gnew() {
    gcap "📦 NEW: $@"
}

# IMPROVE.
function gimp() {
    gcap "👌 IMPROVE: $@"
}

# FIX.
function gfix() {
    gcap "🐛 FIX: $@"
}

# RELEASE.
function grlz() {
    gcap "🚀 RELEASE: $@"
}

# DOC.
function gdoc() {
    gcap "📖 DOC: $@"
}

# TEST.
function gtst() {
    gcap "✅ TEST: $@"
}
