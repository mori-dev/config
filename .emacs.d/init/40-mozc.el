;; https://tottoto.net/build-emacs-mozc-helper-on-sierra/
;; https://tottoto.net/mac-emacs-karabiner-elements-japanese-input-method-config/
;; https://github.com/google/mozc/blob/master/docs/build_mozc_in_osx.md

;; # 作業用ディレクトリを作って移動
;; mkdir ~/src
;; cd ~/src

;; # mozc をダウンロード
;; git clone https://github.com/google/mozc.git -b master --single-branch
;; cd mozc
;; git checkout 73a8154b79b0b8db6cf8e11d6f1e750709c17518
;; git submodule update --init --recursive

;; # パッチを当ててビルドする
;; curl https://gist.githubusercontent.com/koshian/044eaf7a03027ed37a83/raw/90161d80944351160888adbfcb78247e4919f141/mozc_emacs_helper_build.patch | patch -p1
;; cd src
;; GYP_DEFINES="mac_sdk=10.14.6 mac_deployment_target=10.14.6" python build_mozc.py gyp --noqt --branding=GoogleJapaneseInput
;; python build_mozc.py build -c Release unix/emacs/emacs.gyp:mozc_emacs_helper
