---
title: "使用Karabiner将其他键盘配置为类似HHKB的布局"
date: 2018-10-21T16:01:05Z
draft: false
---

# 使用Karabiner将其他键盘配置为类似HHKB的布局

#### 背景说明

配置键盘： `Niz 84键无线蓝牙静电容键盘`

事实上的配置应该是`HHKB lite`的布局，因为非lite版的HHKB键盘左下角都没有`fn`键

但是我用惯了`fn`在左下角的方式，因此我会把HHKB的`left_opt`替换为`fn`,其他键盘类似。

[下载Karabiner-Elements](https://pqrs.org/osx/karabiner), [官方文档](https://pqrs.org/osx/karabiner/json.html#typical-complex_modifications-examples-change-right-shift-x2-to-mission-control)



* 任务
  * `caps_lock ` to `fn`
  * `~` to `Esc` , `Home` to `~`
  * HHKB Arrow Mode (fn + semicolon/slash/open_bracket/quote to arrow keys, etc)

* 问题

  * fn + control + 上下左右不能切换屏幕

* 学习到的知识

  * 在哪里保存`karabiner`映射规则脚本
  * 映射规则基本语法

* 解决方案

  * `optional`添加`control`



#### 视频

<object width="425" height="344"><param name="movie" value="https://www.youtube.com/v/R0OHiyxM2A4&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><embed src="https://www.youtube.com/v/R0OHiyxM2A4&hl=en&fs=1" type="application/x-shockwave-flash" allowfullscreen="true" width="425" height="344"></embed></object>



规则脚本放在`~/.config/karabiner/assets/complex_modifications`

```json
{
  "title": "Happy Hacking Keyboard Compatible Mode (rev 2)",
  "rules": [
    {
      "description": "HHKB Arrow Mode (fn + semicolon/slash/open_bracket/quote to arrow keys, etc)",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "semicolon",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "caps_lock",
                "option",
                "command",
                "control",
                "shift"
              ]
            }
          },
          "to": [
            {
              "key_code": "left_arrow"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "slash",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "caps_lock",
                "option",
                "command",
                "control",
                "shift"
              ]
            }
          },
          "to": [
            {
              "key_code": "down_arrow"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "open_bracket",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "caps_lock",
                "option",
                "command",
                "control",
                "shift"
              ]
            }
          },
          "to": [
            {
              "key_code": "up_arrow"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "quote",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "caps_lock",
                "option",
                "command",
                "control",
                "shift"
              ]
            }
          },
          "to": [
            {
              "key_code": "right_arrow"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "l",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "caps_lock",
                "control",
                "option"
              ]
            }
          },
          "to": [
            {
              "key_code": "page_up"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "period",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "caps_lock",
                "control",
                "option"
              ]
            }
          },
          "to": [
            {
              "key_code": "page_down"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "k",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "caps_lock"
              ]
            }
          },
          "to": [
            {
              "key_code": "home"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "comma",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "caps_lock"
              ]
            }
          },
          "to": [
            {
              "key_code": "end"
            }
          ]
        }
      ]
    },
    {
      "description": "HHKB Media Key Mode (fn + asdf to Volume down/up/mute, eject) (rev 2)",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "a",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "any"
              ]
            }
          },
          "to": [
            {
              "consumer_key_code": "volume_decrement"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "s",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "any"
              ]
            }
          },
          "to": [
            {
              "consumer_key_code": "volume_increment"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "d",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "any"
              ]
            }
          },
          "to": [
            {
              "consumer_key_code": "mute"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "f",
            "modifiers": {
              "mandatory": [
                "fn"
              ],
              "optional": [
                "any"
              ]
            }
          },
          "to": [
            {
              "consumer_key_code": "eject"
            }
          ]
        }
      ]
    },
    {
      "description": "Map fn + i, o, p  to F13, F14, F15.",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "i",
            "modifiers": {
              "mandatory": [
                "fn"
              ]
            }
          },
          "to": [
            {
              "key_code": "f13"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "o",
            "modifiers": {
              "mandatory": [
                "fn"
              ]
            }
          },
          "to": [
            {
              "key_code": "f14"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "p",
            "modifiers": {
              "mandatory": [
                "fn"
              ]
            }
          },
          "to": [
            {
              "key_code": "f15"
            }
          ]
        }
      ]
    }
  ]
}

```

