# export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=~/Dropbox/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/bin:$PATH
# export PATH=/usr/local/Cellar/boost/1.65.0/include:$PATH
# export PATH=/usr/local/Cellar/boost/1.65.0/lib:$PATH
# export PATH=/opt/local/include/boost:$PATH
export GOPATH=$HOME/dev
export PATH=$GOPATH/bin:$PATH

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk

export PYENV_ROOT=$HOME/.pyenv
eval "$(pyenv init -)"
export PATH=$PHPENV_ROOT/shims:$PATH
