---
title: "vim的简单配置"
date: 2016-06-04 17:04:13
draft: false
---

###  说明

我对vi的使用上没什么挑剔的,毕竟多数是在写小程序上使用的
默认的vi其实也够用了不过还是为了增加使用vi时的编码效率还是弄些插件,改改默认配置,在此做个记录

```vim
syntax on       " 语法高亮

set autoindent  " 自动对齐,把当前行的对起格式应用到下一行
set smartindent " 智能的选择对起方式
set smartindent " 开启新行时使用智能自动缩进
set tabstop=4   " 设置tab键为4个空格, 默认8,
set shiftwidth=4" 将换行自动缩进设置成4个空格


set cursorline  " 横线指示当前行

set ruler       " 打开状态栏标尺

set incsearch   " 输入搜索内容时就显示搜索结果
set hlsearch    " 搜索时高亮显示被找到的文本

set showmatch   " 插入括号时，短暂地跳转到匹配的对应括号

set laststatus=2 "显示状态栏 (默认值为 1, 无法显示状态栏)
set cmdheight=1 " 显示状态栏 (默认值为 1, 无法显示状态栏)
" 设置在状态行显示的信息
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)


"普通状态下输入f即可打印出function定义
nnoremap f ofunction () {<ENTER><ESC>i}<ESC>kwi
" 这样分号键就可以进入命令行模式
nnoremap ; :

inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap " ""<ESC>i
inoremap { {}<ESC>i
"输入("时补全");
inoremap (" ("");<ESC>hhi
inoremap then thenend<ESC>hhi<ENTER><BACKSPACE><ESC>ko
```



### 添加颜色主题

关于颜色主题这个不影响使用,但是在实际在linux上使用发现蓝色比较难看清,索性就找找颜色主题替换算了
vim的颜色主题很好修改,在配置文件里面添加 colorscheme 主题名称 就行了
至于主题可以到vim官网或github找
http://www.vim.org/scripts/script.php?script_id=625
下载之后将文件存放在~/.vim/colors, 配置文件上加上`colorscheme 主题名称`(其实就是主题的文件名)

