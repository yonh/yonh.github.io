---
title: "配置Rime输入法"
date: 2018-10-16T06:31:42Z
draft: false
---

### 环境
Ubuntu 18.04

### 目标
* 配置rime输入法，添加双拼方案



### 配置

```shell
# 安装rime和双拼方案
sudo apt install -y fcitx-rime librime-data-double-pinyin

# 创建配置文件 `~/.config/fcitx/rime/default.custom.yaml`并配置。
echo "\
# default.custom.yaml
# save it to:
#   ~/.config/ibus/rime   (linux ibus)
#   ~/.config/fcitx/rime  (linux fcitx)
#   ~/Library/Rime        (macos)
#   %APPDATA%\Rime        (windows)

patch:
  schema_list:
    - schema: luna_pinyin          # 朙月拼音
    - schema: luna_pinyin_simp     # 朙月拼音 简化字模式
    - schema: luna_pinyin_tw       # 朙月拼音 臺灣正體模式
    - schema: terra_pinyin         # 地球拼音 dì qiú pīn yīn
    - schema: bopomofo             # 注音
    - schema: jyutping             # 粵拼
    - schema: cangjie5             # 倉頡五代
    - schema: cangjie5_express     # 倉頡 快打模式
    - schema: quick5               # 速成
    - schema: wubi86               # 五笔 86
    - schema: wubi_pinyin          # 五笔拼音混合輸入
    - schema: double_pinyin        # 自然碼雙拼
    - schema: double_pinyin_mspy   # 微軟雙拼
    - schema: double_pinyin_abc    # 智能 ABC 雙拼
    - schema: double_pinyin_flypy  # 小鶴雙拼
    - schema: wugniu        # 吳語上海話（新派）
    - schema: wugniu_lopha  # 吳語上海話（老派）
    - schema: sampheng      # 中古漢語三拼
    - schema: zyenpheng     # 中古漢語全拼
    - schema: ipa_xsampa    # X-SAMPA 國際音標
    - schema: emoji         # emoji 表情
" > ~/.config/fcitx/rime/default.custom.yaml
```

然后重启`fcitx`，`Ctrl + ~` 调出选择输入法。
