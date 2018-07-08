#!/bin/bash
# sender
gst-launch-1.0 v4l2src ! \
 video/x-raw,width=640,height=480 ! \
 timeoverlay ! \
 tee name="local" ! \
 queue ! \
 autovideosink local. ! \
 queue ! jpegenc! rtpjpegpay ! \
 udpsink host=127.0.0.1 port= 5000
