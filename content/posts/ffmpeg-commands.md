---
title: "ffmpeg常用命令记录"
date: 2018-12-12 07:06:28
draft: false
---

```bash
#### m4a转mp3
ffmpeg -i 许巍2018-12-08慕司之夜-深圳站_录音.m4a -acodec libmp3lame -ab 128k output7.mp3

#### 截取音频片段
# -ss开始 -t截取时间 -y 覆盖文件
ffmpeg -y -i 许巍2018-12-08慕司之夜-深圳站_录音.m4a -acodec copy -ss 00:02:11 -t 00:06:10 output.m4a

#### 单独提取音频(去掉视频)
ffmpeg -i input.mp4 -f mp3 -vn output.mp3
ffmpeg -i input.mp4 -acodec copy -vn output.mp3

#### 单独提取视频(去掉声音)
ffmpeg -i input.mp4 -vcodec copy -an output.mp4

#### 获取视频信息输出json格式
ffprobe -v quiet -print_format json -show_format -show_streams 视频.avi

#### 淡入淡出
## m4a总长度是67.5秒，从66秒开始fade out效果1.5秒。
ffmpeg -i output.m4a -filter_complex afade=t=out:st=66:d=1.5 6075fade.m4a
## 分割视频并给分割出的视频开头和结尾做淡入淡出效果
ffmpeg -ss 20 -i p.mp4 -vf "fade=in:0:50,fade=out:450:50" -t 20 Ok.mp4
ffmpeg -ss 20 -i p.mp4 -vf "fade=in:0:d=1,fade=out:st=29:d=1" -t 20 OK.mp4
```



#### 其他

```bash
#### ffmpeg做水面倒影效果
ffmpeg -i input.avi -vf "split[a][b];[a]pad=iw:ih*2[a];[b]vflip[b];[a][b]overlay=0:h" output.avi
```

