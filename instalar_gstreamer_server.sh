#!/bin/bash

# https://stackoverflow.com/questions/13744560/using-gstreamer-to-serve-rtsp-stream-working-example-sought
# apt-cache search nombrepaquete
# apt-cache search libmount
# la instalacion del autogen da muchos errores por librerias que faltan

sudo apt-get install autoconf automake autopoint libtool

git clone git://anongit.freedesktop.org/gstreamer/gst-rtsp-server && cd gst-rtsp-server

git checkout remotes/origin/1.2

# http://www.linuxfromscratch.org/blfs/view/svn/general/glib2.html

sudo wget http://ftp.gnome.org/pub/gnome/sources/glib/2.56/glib-2.56.1.tar.xz
sudo tar -xf glib-2.56.1.tar.xz
cd glib-2.56.1

sudo apt-get install gettext libmount-dev -y

sudo apt install libxml2-dev libcairo2-dev libreadline-dev libglib2.0-dev libgsl-dev libgtk-3-dev libgtksourceview-3.0-dev gstreamer1.0 -y

sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev -y

# al llegar a este punto ya no deberian faltar mas librerias

./autogen.sh --noconfigure && GST_PLUGINS_GOOD_DIR=$(pkg-config --variable=pluginsdir gstreamer-plugins-bad-1.0) ./configure && make

# se ejecuta el test
cd examples && ./test-launch "( videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96 )"

# usar la ruta en el vlc
