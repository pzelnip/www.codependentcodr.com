Title: Screencaptures on OSX
Date: 2018-03-27 10:20
tags: osxTipOfTheDay,osx
cover: static/imgs/default_page_imagev2.jpg

Oftentimes you want to take a screenshot.  On OSX this is easy: `⌘+SHIFT+4` and you're presented with a rectangle that
allows you to click & select what to capture.  But what happens when you want things like capturing a tooltip, or the
mouse pointer itself.

As it turns out there's a command line utility called `screencapture` that allows you to do this.  To capture the screen
and include the mouse pointer, you can do:

```shell
screencapture -T 5 -C ~/Desktop/screencap.png
```

and then in 5 seconds the current screen will be saved to `~/Desktop/screencap.png` and include the mouse pointer in the
image.

But what happens when you have an external display?  How do you capture those screens.  Well, the answer is in the
`--help` output of the command which reads:

```shell
$ screencapture --help
screencapture: illegal option -- -
usage: screencapture [-icMPmwsWxSCUtoa] [files]
  -c         force screen capture to go to the clipboard
  -b         capture Touch Bar - non-interactive modes only
  -C         capture the cursor as well as the screen. only in non-interactive modes
  -d         display errors to the user graphically
  -i         capture screen interactively, by selection or window
               control key - causes screen shot to go to clipboard
               space key   - toggle between mouse selection and
                             window selection modes
               escape key  - cancels interactive screen shot
  -m         only capture the main monitor, undefined if -i is set
  -M         screen capture output will go to a new Mail message
  -o         in window capture mode, do not capture the shadow of the window
  -P         screen capture output will open in Preview
  -I         screen capture output will in a new Messages message
  -s         only allow mouse selection mode
  -S         in window capture mode, capture the screen not the window
  -t<format> image format to create, default is png (other options include pdf, jpg, tiff and other formats)
  -T<seconds> Take the picture after a delay of <seconds>, default is 5
  -w         only allow window selection mode
  -W         start interaction in window selection mode
  -x         do not play sounds
  -a         do not include windows attached to selected windows
  -r         do not add dpi meta data to image
  -l<windowid> capture this windowsid
  -R<x,y,w,h> capture screen rect
  -B<bundleid> screen capture output will open in app with bundleidBS
  files   where to save the screen capture, 1 file per screen
```

Note that last line, `files   where to save the screen capture, 1 file per screen`.  So we just add an additional file
per screen.  So if you have 2 external displays, you'd do something like:

```shell
screencapture -T 5 -C ~/Desktop/screen1.png ~/Desktop/screen2.png ~/Desktop/screen3.png
```

And three files will be saved, one for each screen.
