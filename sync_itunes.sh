#!/bin/sh

rsync -aurz --delete -e ssh /Users/ryoe/Music/iTunes/iTunes\ Media/Music ryoeshi@umenew:/mnt/share/music/iTunes & 2>&1 | tee sync_itunes.log

