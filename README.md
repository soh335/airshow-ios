# airshow-ios

**it is alpha quority**

airshow is play slideshow on appletv.
if you want to play other site ( currently, default sites is only tumblr ), you can write source.
Source is plugin for airshow.

## defualt source

* tumblr (blog)

## ASWConfig.h

If you want to compile airshow, you need to add ASWConfig.h to target.
ASWConfig.h should define "ASW_TUMBLR_API_KEY" macro, like this.

```
#define ASW_TUMBLR_API_KEY @"xxxxxxxxxxxxxxxxxxx"
```

## require

* cocoapods

## thanks

* http://nto.github.io/AirPlay.html

airshow depends cocoapods.
