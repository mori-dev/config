// ========================== KeySnail Init File =========================== //

// この領域は, GUI により設定ファイルを生成した際にも引き継がれます
// 特殊キー, キーバインド定義, フック, ブラックリスト以外のコードは, この中に書くようにして下さい
// ========================================================================= //
//{{%PRESERVE%
// ここにコードを入力して下さい
//
// prompt の行数を指定
prompt.rows = 18;
// XUL/Migemo を使用するかどうか
prompt.useMigemo = false;
// 何文字から Migemo を使用するか (2 なら ra と二文字入力してはじめて Migemo が使われる)
prompt.migemoMinWordLength = 2;
// 文字を入力してから検索開始までの遅延時間 (ミリ秒)
prompt.displayDelayTime = 200;

//bmany で選択したブックマークを前面の新しいタブで開く
plugins.options["bmany.default_open_type"] = "tab";

// twitter Enter ではなく Ctrl + Enter でポストする
plugins.options["twitter_client.tweet_keymap"] = {
    "C-RET" : "prompt-decide",
    "RET"   : ""
};


// /usr/bin/chromium-browser
plugins.options['launcher.apps'] = {
    'wmctrl-emacs': {                               // 実行時に使用するキー
        description: 'activate emacs by wmctrl',   // 説明
        path: '/usr/bin/wmctrl',                   // 実行ファイルのフルパス
        defaultArgs: ['-a', 'emacs'],              // 実行時に渡すパラメータ(Array)
    },
    'google-chrome': {
        description: 'Open with Google Chrome',
        path: '/usr/bin/google-chrome',
        defaultArgs: ['%URL'],                     // 現在の URL を渡す
    }
};


// 日本語だけトラッキング
plugins.options["twitter_client.tracking_langage"] = "ja";

key.setViewKey('C-8', function () {
    ext.exec("list-closed-tabs");
}, '最近閉じたタブを一覧表示');



//サイトローカルプラグイン
var local = {};
plugins.options["site_local_keymap.local_keymap"] = local;

function fake(k, i) function () { key.feed(k, i); };
function pass(k, i) [k, fake(k, i)];
function ignore(k, i) [k, null];

local["^http://reader.livedoor.com/reader/"] = [
    ['j', null],
    ['s', null],
    ['a', null],
    ['c', null],
];


//}}%PRESERVE%
// ========================================================================= //

// ========================= Special key settings ========================== //

key.quitKey              = "C-g";
key.helpKey              = "<f1>";
key.escapeKey            = "C-q";
key.macroStartKey        = "Not defined";
key.macroEndKey          = "Not defined";
key.universalArgumentKey = "C-u";
key.negativeArgument1Key = "C--";
key.negativeArgument2Key = "C-M--";
key.negativeArgument3Key = "M--";
key.suspendKey           = "<f2>";

// ================================= Hooks ================================= //

hook.setHook('KeyBoardQuit', function (aEvent) {
    if (key.currentKeySequence.length) {
        return;
    }
    command.closeFindBar();
    var marked = command.marked(aEvent);
    if (util.isCaretEnabled()) {
        if (marked) {
            command.resetMark(aEvent);
        } else {
            if ("blur" in aEvent.target) {
                aEvent.target.blur();
            }
            gBrowser.focus();
            _content.focus();
        }
    } else {
        goDoCommand("cmd_selectNone");
    }
    if (KeySnail.windowType === "navigator:browser" && !marked) {
        key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_ESCAPE, true);
    }
});

hook.setHook('LocationChange', function (aNsURI) {
    if (!aNsURI || !aNsURI.spec) {
        return;
    }
    const wikipediaRegexp = "^http://[a-zA-Z]+\\.wikipedia\\.org/";
    if (aNsURI.spec.match(wikipediaRegexp)) {
        var doc = content.document;
        if (doc && !doc.__ksAccesskeyKilled__) {
            doc.addEventListener("DOMContentLoaded", function () {
                doc.removeEventListener("DOMContentLoaded", arguments.callee, true);
                var nodes = doc.evaluate("//*[@accesskey]", doc, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
                for (let i = 0; i < nodes.snapshotLength; i++) {
                    let node = nodes.snapshotItem(i);
                    let clone = node.cloneNode(true);
                    clone.removeAttribute("accesskey");
                    node.parentNode.replaceChild(clone, node);
                }
                doc.__ksAccesskeyKilled__ = true;
            },
            true);
        }
    }
});


// ============================= Key bindings ============================== //

key.setGlobalKey([['C-M-r'], ['ESC', 'r']], function () {
    userscript.reload();
}, '設定ファイルを再読み込み', true);

key.setGlobalKey([['ESC', 'x'], ['M-x']], function (aEvent, aArg) {
    ext.select(aArg, aEvent);
}, 'エクステ一覧');

key.setGlobalKey([['ESC', ':'], ['M-:']], function () {
    command.interpreter();
}, 'コマンドインタプリタ', true);

key.setGlobalKey([['ESC', 'j'], ['C-3']], function (ev, arg) {
    ext.exec("firebug-toggle", arg, ev);
}, 'firebug の on/off', true);

key.setGlobalKey([['ESC', 'c'], ['C-1']], function (ev, arg) {
    ext.exec("firebug-console-clear", arg, ev);
}, 'firebug のコンソールをクリア', true);

key.setGlobalKey([['ESC', 'o'], ['C-2']], function (ev, arg) {
    ext.exec("firebug-console-focus", arg, ev);
}, 'firebug の on/off', true);

key.setGlobalKey([['ESC', 'e'], ['C-M-e']], function (ev, arg) {
    ext.exec("firebug-tab", arg, ev);
}, 'firebug の tab 選択', true);

key.setGlobalKey([['ESC', 'w'], ['M-w'], ['C-M-w']], function (aEvent) {
    command.copyRegion(aEvent);
}, '選択中のテキストをコピー', true);

key.setGlobalKey(['ESC', 'ESC'], function (ev, arg) {
    ev.originalTarget.dispatchEvent(key.stringToKeyEvent("ESC", true));
}, 'ESC キーイベントを投げる');

key.setGlobalKey([['C-x', 'h'], ['C-x', 'C-h']], function () {
    goDoCommand("cmd_selectAll");
}, 'すべて選択', true);

key.setGlobalKey(['C-x', 'l'], function () {
    command.focusToById("urlbar");
}, 'ロケーションバーへフォーカス', true);

key.setGlobalKey(['C-x', 'g'], function () {
    command.focusToById("searchbar");
}, '検索バーへフォーカス', true);

key.setGlobalKey(['C-x', 'k'], function () {
    BrowserCloseTabOrWindow();
}, 'タブ / ウィンドウを閉じる');

key.setGlobalKey(['C-x', 'C-k'], function () {
    BrowserCloseTabOrWindow();
}, 'タブ / ウィンドウを閉じる');

key.setGlobalKey(['C-x', 'K'], function () {
    closeWindow(true);
}, 'ウィンドウを閉じる');

key.setGlobalKey(['C-x', 'C-c'], function () {
    goQuitApplication();
}, 'Firefox を終了', true);

key.setGlobalKey(['C-x', 'C-f'], function () {
    BrowserOpenFileWindow();
}, 'ファイルを開く', true);

key.setGlobalKey(['C-x', 'C-s'], function () {
    saveDocument(window.content.document);
}, 'ファイルを保存', true);

key.setGlobalKey(['C-x', ';'], function (aEvent, aArg) {
    prompt.selector({message: "pattern:", collection: ["a", "b"], callback: function (i) {switch (i) {case 0:alert(firemobilesimulator.common.pref.getListPref());break;case 1:alert(5555);break;default:alert(i);}}});
}, 'UA切替');

key.setGlobalKey(['C-x', 'u'], function () {
    undoCloseTab();
}, '閉じたタブを元に戻す');

key.setGlobalKey('C-m', function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_RETURN, true);
}, 'リターンコードを生成');

key.setGlobalKey(['C-j', 'C-j'], function (ev, arg) {
    ext.exec("JsReferrence-open-prompt", arg, ev);
}, 'JsReferrenceで検索を開始する', true);

key.setGlobalKey(['C-j', 'C-r'], function (ev, arg) {
    ext.exec("JsReferrence-reIndex", arg, ev);
}, 'JsReferrenceののインデックスを作り直す', true);

key.setGlobalKey('C-s', function () {
    command.iSearchForward();
}, 'インクリメンタル検索', true);

key.setGlobalKey('C-r', function () {
    command.iSearchBackward();
}, '逆方向インクリメンタル検索', true);

key.setGlobalKey(['C-c', 'C-c', 'C-v'], function () {
    toJavaScriptConsole();
}, 'Javascript コンソールを表示', true);

key.setGlobalKey(['C-c', 'C-c', 'C-c'], function () {
    command.clearConsole();
}, 'Javascript コンソールの表示をクリア', true);

key.setGlobalKey(['C-c', 't'], function (ev, arg) {
    ext.exec("twitter-client-tweet", arg);
}, 'つぶやく', true);

key.setGlobalKey(['C-c', 'T'], function (ev, arg) {
    ext.exec("twitter-client-tweet-this-page", arg);
}, 'このページのタイトルと URL を使ってつぶやく', true);

key.setGlobalKey(['C-c', '@'], function (ev, arg) {
    ext.exec("twitter-client-show-mentions", arg);
}, 'このページのタイトルと URL を使ってつぶやく', true);

key.setGlobalKey(['C-c', 'q'], function (ev, arg) {
    ext.exec("readability", arg);
}, 'readability', true);

// key.setGlobalKey('C-<f5>', function (ev) {
//     userscript.reload();
// }, '設定ファイルを再読み込み');

key.setViewKey('C-8', function () {
    ext.exec("list-closed-tabs");
}, '最近閉じたタブを一覧表示');

key.setViewKey([['C-f'], ['f']], function () {
    BrowserForward();
}, '進む');

key.setViewKey('.', function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_LEFT, true);
}, '左へスクロール');

key.setViewKey([['C-b'], ['b']], function (aEvent) {
    BrowserBack();
}, '戻る', true);

key.setViewKey(',', function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_RIGHT, true);
}, '右へスクロール');

key.setViewKey('C-v', function () {
    goDoCommand("cmd_scrollPageDown");
}, '一画面スクロールダウン');

key.setViewKey([['M-<'], ['g'], ['ESC', '<']], function () {
    goDoCommand("cmd_scrollTop");
}, 'ページ先頭へ移動', true);

key.setViewKey([['ESC', '>'], ['M->'], ['G']], function () {
    goDoCommand("cmd_scrollBottom");
}, 'ページ末尾へ移動', true);

key.setViewKey([['ESC', 'p'], ['M-p']], function () {
    command.walkInputElement(command.elementsRetrieverButton, true, true);
}, '次のボタンへフォーカスを当てる');

key.setViewKey([['ESC', 'n'], ['M-n']], function () {
    command.walkInputElement(command.elementsRetrieverButton, false, true);
}, '前のボタンへフォーカスを当てる');

key.setViewKey([['ESC', 'g'], ['C-p'], ['k'], ['C-M-g']], function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_UP, true);
}, '一行スクロールアップ');

key.setViewKey([['ESC', 'v'], ['C-n'], ['j'], ['C-M-v']], function (aEvent) {
    key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_DOWN, true);
}, '一行スクロールダウン');

key.setViewKey([['ESC', 'b'], ['M-b']], function (aEvent) {
    prompt.read("\u30C9\u30E1\u30A4\u30F3\u5185\u691C\u7D22:", function (query) {if (window.loadURI) {getBrowser().selectedTab = getBrowser().addTab("http://www.google.com/search?q=site:" + window.content.document.location.host + " " + encodeURIComponent(query));}});
}, 'ドメイン内検索');


key.setViewKey([['ESC', 'b'], ['M-c']], function (aEvent) {
    prompt.read("はてブタグ", function (query) {if (window.loadURI) {getBrowser().selectedTab = getBrowser().addTab("http://b.hatena.ne.jp/kitokitoki/" + encodeURIComponent(query));}});
}, 'はてブタグ');

key.setViewKey(['ESC', 'ESC'], function (ev, arg) {
    ev.originalTarget.dispatchEvent(key.stringToKeyEvent("ESC", true));
}, 'ESC キーイベントを投げる');

key.setViewKey('M-v', function () {
    goDoCommand("cmd_scrollPageUp");
}, '一画面分スクロールアップ');

key.setViewKey('l', function () {
    gBrowser.mTabContainer.advanceSelectedTab(1, true);
}, 'ひとつ右のタブへ');

key.setViewKey('h', function () {
    gBrowser.mTabContainer.advanceSelectedTab(-1, true);
}, 'ひとつ左のタブへ');

key.setViewKey(['C-x', 'h'], function () {
    goDoCommand("cmd_selectAll");
}, 'すべて選択', true);

key.setViewKey('E', function (aEvent, aArg) {
    ext.exec("hok-start-foreground-mode", aArg);
}, 'Hit a Hint を開始', true);

key.setViewKey('e', function (aEvent, aArg) {
    ext.exec("hok-start-background-mode", aArg);
}, 'リンクをバックグラウンドで開く Hit a Hint を開始', true);

key.setViewKey(';', function (aEvent, aArg) {
    ext.exec("hok-start-extended-mode", aArg);
}, 'HoK - 拡張ヒントモード', true);

key.setViewKey(['C-c', 'C-e'], function (aEvent, aArg) {
    ext.exec("hok-start-continuous-mode", aArg);
}, 'リンクを連続して開く Hit a Hint を開始', true);

key.setViewKey('C-9', function (ev, arg) {
    ext.exec("bmany-list-all-bookmarks", arg, ev);
}, 'ブックマーク');

key.setViewKey(['C-0', 'P'], function (ev, arg) {
    ext.exec("bmany-list-bookmarklets", arg, ev);
}, 'bmany - ブックマークレットを一覧表示');

key.setViewKey(['\\', 'k'], function (ev, arg) {
    ext.exec("bmany-list-bookmarks-with-keyword", arg, ev);
}, 'bmany - キーワード付きブックマークを一覧表示');

key.setViewKey('C-l', function (ev, arg) {
    ext.exec("tanything", arg);
}, 'タブを一覧表示', true);

key.setViewKey(':', function () {
    shell.input();
}, 'Command System');

key.setViewKey('c', function (ev, arg) {
    ext.exec("list-hateb-comments", arg);
}, 'はてなブックマークのコメントを一覧表示', true);

key.setViewKey('a', function (ev, arg) {
    ext.exec("hateb-bookmark-this-page");
}, 'このページをはてなブックマークに追加', true);

key.setViewKey('B', function (ev, arg) {
    ext.exec("list-hateb-items");
}, '自分のはてブ一覧', true);

key.setViewKey('r', function () {
    BrowserReload();
}, '更新', true);

key.setViewKey('>', function (ev, arg) {
    var pattern = /(.*?)([0]*)([0-9]+)([^0-9]*)$/;
    var url = content.location.href;
    var digit = url.match(pattern);
    if (digit[1] && digit[3]) {
        let len = digit[3].length;
        let next = + digit[3] + (arg ? arg : 1);
        content.location.href = digit[1] + (digit[2] || "").slice(next.toString().length - len) + next + (digit[4] || "");
    }
}, 'Increment last digit in the URL');

key.setViewKey('<', function (ev, arg) {
    var pattern = /(.*?)([0]*)([0-9]+)([^0-9]*)$/;
    var url = content.location.href;
    var digit = url.match(pattern);
    if (digit[1] && digit[3]) {
        let len = digit[3].length;
        let next = + digit[3] - (arg ? arg : 1);
        content.location.href = digit[1] + (digit[2] || "").slice(next.toString().length - len) + next + (digit[4] || "");
    }
}, 'Decrement last digit in the URL');




key.setViewKey('t', function (ev, arg) {
    ext.exec("twitter-client-display-timeline", arg);
}, 'TL を表示', true);

//key.setViewKey('S', function () {
//    shell.input("open ");
//}, 'Open');

key.setViewKey('S', function (ev, arg) {
    // shell.input("tabopen google " + (content.document.getSelection() || "").replace(/[, ]/g, "\\$&"));
    shell.input("tabopen google " + (content.document.getSelection().toString() || "").replace(/[, ]/g, "\\$&"));
}, 'Google word');

key.setViewKey('s', function (ev, arg) {
    // shell.input("tabopen google " + (content.document.getSelection() || "").replace(/[, ]/g, "\\$&"));
    shell.input("tabopen google " + (content.document.getSelection().toString() || "").replace(/[, ]/g, "\\$&"));
}, 'Google word');

key.setViewKey('U', function () {
    var d = window.content.document;
    var txt = "[" + d.location.href + ":title=" + d.title + "]";
    const CLIPBOARD = Components.classes['@mozilla.org/widget/clipboardhelper;1'].getService(Components.interfaces.nsIClipboardHelper);
    CLIPBOARD.copyString(txt);
}, 'はてな記法のリンク生成');

key.setViewKey('M', function () {
    var d = window.content.document;
    var txt = "[" + d.title + "](" + d.location.href + ")";
    const CLIPBOARD = Components.classes['@mozilla.org/widget/clipboardhelper;1'].getService(Components.interfaces.nsIClipboardHelper);
    CLIPBOARD.copyString(txt);
}, 'Markdown記法のリンク生成');

key.setViewKey('i', function (aEvent) {
    ext.exec("set_Caret", arg);
}, 'キャレットモード', true);

// https://raw.githubusercontent.com/azu/KeySnail-Plugins/master/displayLastModified/displayLastModified.ks.js
key.setViewKey([['C-b', 'l'],['C-b', 'C-l']], function (ev, arg) {
    ext.exec('displayLastModified-URL', arg, ev);
}, 'ページの最終更新日を表示', true);

key.setEditKey([['C-SPC'], ['C-@']], function (aEvent) {
    command.setMark(aEvent);
}, 'マークをセット', true);

key.setEditKey('C-o', function (aEvent) {
    command.openLine(aEvent);
}, '行を開く (Open line)');

key.setEditKey([['C-x', 'u'], ['C-/']], function () {
    display.echoStatusBar("Undo!", 2000);
    goDoCommand("cmd_undo");
}, 'アンドゥ');

key.setEditKey(['C-x', 'r', 'd'], function (aEvent, aArg) {
    command.replaceRectangle(aEvent.originalTarget, "", false, !aArg);
}, '矩形削除', true);

key.setEditKey(['C-x', 'r', 't'], function (aEvent) {
    prompt.read("String rectangle: ", function (aStr, aInput) {command.replaceRectangle(aInput, aStr);}, aEvent.originalTarget);
}, '矩形置換', true);

key.setEditKey(['C-x', 'r', 'o'], function (aEvent) {
    command.openRectangle(aEvent.originalTarget);
}, '矩形行空け', true);

key.setEditKey(['C-x', 'r', 'k'], function (aEvent, aArg) {
    command.kill.buffer = command.killRectangle(aEvent.originalTarget, !aArg);
}, '矩形キル', true);

key.setEditKey(['C-x', 'r', 'y'], function (aEvent) {
    command.yankRectangle(aEvent.originalTarget, command.kill.buffer);
}, '矩形ヤンク', true);

key.setEditKey('C-\\', function () {
    display.echoStatusBar("Redo!", 2000);
    goDoCommand("cmd_redo");
}, 'リドゥ');

key.setEditKey('C-a', function (aEvent) {
    command.beginLine(aEvent);
}, '行頭へ移動');

key.setEditKey('C-e', function (aEvent) {
    command.endLine(aEvent);
}, '行末へ');

key.setEditKey('C-f', function (aEvent) {
    command.nextChar(aEvent);
}, '一文字右へ移動');

key.setEditKey('C-b', function (aEvent) {
    command.previousChar(aEvent);
}, '一文字左へ移動');

key.setEditKey('C-n', function (aEvent) {
    command.nextLine(aEvent);
}, '一行下へ');

key.setEditKey('C-p', function (aEvent) {
    command.previousLine(aEvent);
}, '一行上へ');

key.setEditKey('C-v', function (aEvent) {
    command.pageDown(aEvent);
}, '一画面分下へ');

key.setEditKey([['M-v'], ['ESC', 'v']], function (aEvent) {
    command.pageUp(aEvent);
}, '一画面分上へ');

key.setEditKey([['ESC', '<'], ['M-<']], function (aEvent) {
    command.moveTop(aEvent);
}, 'テキストエリア先頭へ');

key.setEditKey([['ESC', '>'], ['M->']], function (aEvent) {
    command.moveBottom(aEvent);
}, 'テキストエリア末尾へ');

key.setEditKey([['ESC', 'd'], ['M-d']], function () {
    goDoCommand("cmd_deleteWordForward");
}, '次の一単語を削除');

key.setEditKey([['ESC', '<delete>'], ['C-<backspace>'], ['M-<delete>']], function () {
    goDoCommand("cmd_deleteWordBackward");
}, '前の一単語を削除');

key.setEditKey([['ESC', 'u'], ['M-u']], function (aEvent) {
    command.processForwardWord(aEvent.originalTarget, function (aString) {return aString.toUpperCase();});
}, '次の一単語を全て大文字に (Upper case)');

key.setEditKey([['ESC', 'l'], ['M-l']], function (aEvent) {
    command.processForwardWord(aEvent.originalTarget, function (aString) {return aString.toLowerCase();});
}, '次の一単語を全て小文字に (Lower case)');

key.setEditKey([['ESC', 'c'], ['M-c']], function (aEvent) {
    command.processForwardWord(aEvent.originalTarget, command.capitalizeWord);
}, '次の一単語をキャピタライズ');

key.setEditKey([['ESC', 'y'], ['M-y']], command.yankPop, '古いクリップボードの中身を順に貼り付け (Yank pop)', true);

key.setEditKey([['ESC', 'n'], ['M-n']], function () {
    command.walkInputElement(command.elementsRetrieverTextarea, true, true);
}, '次のテキストエリアへフォーカス');

key.setEditKey([['ESC', 'p'], ['M-p']], function () {
    command.walkInputElement(command.elementsRetrieverTextarea, false, true);
}, '前のテキストエリアへフォーカス');

key.setEditKey([['ESC', 'f'], ['M-f'], ['C-M-f']], function (aEvent) {
    command.nextWord(aEvent);
}, '一単語右へ移動');

key.setEditKey([['ESC', 'b'], ['M-b'], ['C-M-b']], function (aEvent) {
    command.previousWord(aEvent);
}, '一単語左へ移動');

key.setEditKey(['ESC', 'ESC'], function (ev, arg) {
    ev.originalTarget.dispatchEvent(key.stringToKeyEvent("ESC", true));
}, 'ESC キーイベントを投げる');

key.setEditKey('C-M-y', function (aEvent) {
    if (!command.kill.ring.length) {
        return;
    }
    let (ct = command.getClipboardText()) (!command.kill.ring.length || ct != command.kill.ring[0]) &&
        command.pushKillRing(ct);
    prompt.selector({message: "Paste:", collection: command.kill.ring, callback: function (i) {if (i >= 0) {key.insertText(command.kill.ring[i]);}}});
}, '以前にコピーしたテキスト一覧から選択して貼り付け', true);

key.setEditKey('C-d', function () {
    goDoCommand("cmd_deleteCharForward");
}, '次の一文字削除');

key.setEditKey('C-h', function () {
    goDoCommand("cmd_deleteCharBackward");
}, '前の一文字を削除');

key.setEditKey('C-k', function (aEvent) {
    command.killLine(aEvent);
}, 'カーソルから先を一行カット (Kill line)');


key.setEditKey('C-y', command.yank, '貼り付け (Yank)');

// key.setEditKey('C-k', function (aEvent) {
//     window.alert("afds");
// }, 'カーソルから先を一行カット (Kill line)');

// key.setEditKey('C-y', function (aEvent) {
//     window.alert("afds");
// }, 'カーソルから先を一行カット (Kill line)');



key.setEditKey('C-w', function (aEvent) {
    goDoCommand("cmd_copy");
    goDoCommand("cmd_delete");
    command.resetMark(aEvent);
}, '選択中のテキストを切り取り (Kill region)', true);

key.setCaretKey([['C-a'], ['^']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectBeginLine") : goDoCommand("cmd_beginLine");
}, 'キャレットを行頭へ移動');

key.setCaretKey([['C-e'], ['$'], ['M->'], ['G'], ['ESC', '>']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectEndLine") : goDoCommand("cmd_endLine");
}, 'キャレットを行末へ移動');

key.setCaretKey([['ESC', 'f'], ['M-f'], ['w']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectWordNext") : goDoCommand("cmd_wordNext");
}, 'キャレットを一単語右へ移動');

key.setCaretKey([['ESC', 'b'], ['M-b'], ['W']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectWordPrevious") : goDoCommand("cmd_wordPrevious");
}, 'キャレットを一単語左へ移動');

key.setCaretKey([['ESC', '<'], ['M-<'], ['g']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectTop") : goDoCommand("cmd_scrollTop");
}, 'キャレットをページ先頭へ移動');

key.setCaretKey([['ESC', 'p'], ['M-p']], function () {
    command.walkInputElement(command.elementsRetrieverButton, true, true);
}, '次のボタンへフォーカスを当てる');

key.setCaretKey([['ESC', 'n'], ['M-n']], function () {
    command.walkInputElement(command.elementsRetrieverButton, false, true);
}, '前のボタンへフォーカスを当てる');

key.setCaretKey([['ESC', 'v'], ['M-v'], ['b']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectPagePrevious") : goDoCommand("cmd_movePageUp");
}, 'キャレットを一画面分上へ');

key.setCaretKey(['ESC', 'ESC'], function (ev, arg) {
    ev.originalTarget.dispatchEvent(key.stringToKeyEvent("ESC", true));
}, 'ESC キーイベントを投げる');

key.setCaretKey([['C-n'], ['j']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectLineNext") : goDoCommand("cmd_scrollLineDown");
}, 'キャレットを一行下へ');

key.setCaretKey([['C-p'], ['k']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectLinePrevious") : goDoCommand("cmd_scrollLineUp");
}, 'キャレットを一行上へ');

key.setCaretKey([['C-f'], ['l']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectCharNext") : goDoCommand("cmd_scrollRight");
}, 'キャレットを一文字右へ移動');

key.setCaretKey([['C-b'], ['h'], ['C-h']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectCharPrevious") : goDoCommand("cmd_scrollLeft");
}, 'キャレットを一文字左へ移動');

key.setCaretKey('J', function () {
    util.getSelectionController().scrollLine(true);
}, '画面を一行分下へスクロール');

key.setCaretKey('K', function () {
    util.getSelectionController().scrollLine(false);
}, '画面を一行分上へスクロール');

key.setCaretKey(',', function () {
    util.getSelectionController().scrollHorizontal(true);
    goDoCommand("cmd_scrollLeft");
}, '左へスクロール');

key.setCaretKey('.', function () {
    goDoCommand("cmd_scrollRight");
    util.getSelectionController().scrollHorizontal(false);
}, '右へスクロール');

key.setCaretKey('z', function (aEvent) {
    command.recenter(aEvent);
}, 'キャレットの位置までスクロール');

key.setCaretKey([['C-SPC'], ['C-@']], function (aEvent) {
    command.setMark(aEvent);
}, 'マークをセット', true);

key.setCaretKey('R', function () {
    BrowserReload();
}, '更新', true);

key.setCaretKey(['C-x', 'h'], function () {
    goDoCommand("cmd_selectAll");
}, 'すべて選択', true);

key.setCaretKey('f', function () {
    command.focusElement(command.elementsRetrieverTextarea, 0);
}, '最初のインプットエリアへフォーカス', true);

key.setCaretKey([['C-v'], ['SPC']], function (aEvent) {
    aEvent.target.ksMarked ? goDoCommand("cmd_selectPageNext") : goDoCommand("cmd_movePageDown");
}, 'キャレットを一画面分下へ');

key.setCaretKey('s', function (ev, arg) {
    shell.input("tabopen google " + (content.document.getSelection() || "").replace(/[, ]/g, "\\$&"));
}, 'Google word');

key.setCaretKey('i', function (aEvent) {
    ext.exec("remove_Caret", arg);
}, 'キャレットモードをキャンセル', true);

key.setGlobalKey('M-n', function (ev, arg) {
    ext.exec('find-all-tab', arg, ev);
}, 'Find - 全てのタブを検索', true);

key.setGlobalKey('M-o', function (ev, arg) {
    ext.exec('find-current-tab', arg, ev);
}, 'Find - 現在のタブを検索', true);



//imenu

ext.add("imenu-headers", function () {
  let anchorSelector = [
    "h1",
    "h2",
    "h3",
    "h4"
  ].join(",");

  let elements = Array.slice(content.document.querySelectorAll(anchorSelector));

  function elementToString(element) {
    let headerString = "",
        matched = null;
    if ((matched = element.localName.match(/h([0-9])/))) {
      let headerCount = parseInt(matched[1], 10);
      headerString = (new Array(headerCount)).join("  ");

      let headerMarks = {
        1: '',            /* none */
        2: "\u2023",      /* right arrow */
        3: "\u2022",      /* bullet */
        4: "\u25E6"       /* white bullet */
      };

      if (headerMarks[headerCount])
        headerString = headerString + headerMarks[headerCount] + " ";
    }

    return headerString + element.textContent;
  }

  function scrollToElement(element) {
    let anchor = element.getAttribute("id") || element.getAttribute("name");
    if (anchor)
      content.location.hash = anchor;
    else
      element.scrollIntoView();
  }

  prompt.selector({
    message: "jump to: ",
    collection: elements.map(function (element) elementToString(element)),
    callback: function (selectedIndex) {
      if (selectedIndex < 0)
        return;
      scrollToElement(elements[selectedIndex]);
    }
  });
}, "imenu-headers", true);


key.setGlobalKey("M-i", function (ev) {
  ext.exec("imenu-headers");
}, 'jump to headers');


// C-d か M-d でロケーションバーへ。
key.setGlobalKey([['C-d'], ['M-d']], function (ev, arg) {
    var urb = document.getElementById("urlbar");
    if (ev.target === urb) {
        urb.blur();
        gBrowser.focus();
        content.focus();
    } else { ! document.getElementById("urlbar").hidden && urb.focus();
    }
}, 'トグル URLバーのフォーカス');
