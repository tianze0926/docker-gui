export XDG_RUNTIME_DIR="/run/user/$(id -u abc)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
export DISPLAY=:0
mkdir -m 1777 /tmp/.X11-unix
install -d -m 700 -o abc -g users ${XDG_RUNTIME_DIR}

exec /usr/bin/supervisord