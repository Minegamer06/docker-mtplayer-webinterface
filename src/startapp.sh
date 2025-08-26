#!/bin/sh
export HOME=/config

# Set JAVA_OPTS if JAVA_MAX_RAM is provided
if [ -n "$JAVA_MAX_RAM" ]; then
    JAVA_OPTS="-Xmx$JAVA_MAX_RAM"
    echo "Setting Java max RAM to $JAVA_MAX_RAM"
fi

# Determine if Auto Mode should be enabled based on MTPLAYER_AUTO env variable
if [ "$MTPLAYER_AUTO" = "true" ]; then
    AUTO_FLAG="-a"
    echo "Starting MTPlayer in Auto Mode"
else
    AUTO_FLAG=""
    echo "Starting MTPlayer in Normal Mode"
fi

# Start MTPlayer with $HOME for configuration, and auto mode if enabled
exec java $JAVA_OPTS -jar /app/mtplayer/MTPlayer.jar $HOME $AUTO_FLAG "$@"