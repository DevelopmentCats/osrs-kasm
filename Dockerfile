FROM kasmweb/ubuntu-noble-desktop:1.17.0

USER root
ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jre \
    openjdk-11-jdk \
    libgl1-mesa-dev \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    mesa-utils \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    libegl1-mesa-dev \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxcursor1 \
    libxinerama1 \
    libxxf86vm1 \
    libxkbfile1 \
    libxss1 \
    libxext6 \
    libdrm2 \
    libasound2t64 \
    pulseaudio-utils \
    unclutter \
    xdotool \
    wmctrl \
    fonts-dejavu-core \
    fontconfig \
    wget \
    curl \
    flatpak \
    libopenh264-7 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN flatpak remote-add --system flathub https://flathub.org/repo/flathub.flatpakrepo \
    && flatpak install -y --system flathub com.adamcake.Bolt

RUN echo 'deadline' > /sys/block/*/queue/scheduler 2>/dev/null || true

RUN mkdir -p /opt/bolt \
    && cat > /opt/bolt/osrs-launcher.sh << 'EOF'
#!/bin/bash
export DISPLAY=:1

BOLT_PATH=$(find /var/lib/flatpak/app/com.adamcake.Bolt -name "bolt-launcher" -type d 2>/dev/null | head -1)
if [[ -z "$BOLT_PATH" ]]; then
    echo "Error: Bolt launcher not found"
    exit 1
fi

BOLT_LIB_PATH=$(dirname "$BOLT_PATH")/../lib
JVM_LIB_PATH="/usr/lib/jvm/java-11-openjdk-amd64/lib/server"
export LD_LIBRARY_PATH="$BOLT_LIB_PATH:$JVM_LIB_PATH:$LD_LIBRARY_PATH"

mkdir -p "$HOME/.jagex_cache_32" "$HOME/.jagex" "$HOME/.jagex/cache" "$HOME/.runelite"

sleep 5

xfconf-query -c xfce4-panel -p /panels/panel-1/autohide -s true 2>/dev/null || true
xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 0 2>/dev/null || true

{
    while true; do
        GAME_WINDOW=$(wmctrl -l | grep -i -E "runelite|oldschool|old school|bolt" | head -1)
        
        if [[ -n "$GAME_WINDOW" ]]; then
            WINDOW_ID=$(echo "$GAME_WINDOW" | awk '{print $1}')
            
            GEOMETRY=$(xwininfo -id "$WINDOW_ID" 2>/dev/null | grep -E "Width:|Height:")
            WIDTH=$(echo "$GEOMETRY" | grep "Width:" | awk '{print $2}')
            HEIGHT=$(echo "$GEOMETRY" | grep "Height:" | awk '{print $2}')
            
            if [[ "$WIDTH" -gt 700 && "$HEIGHT" -gt 500 ]]; then
                wmctrl -i -r "$WINDOW_ID" -b add,maximized_vert,maximized_horz
                sleep 5
            fi
        fi
        
        sleep 2
    done
} &

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export JAVA_TOOL_OPTIONS="-Djava.net.preferIPv4Stack=true -Djava.awt.headless=false -Dsun.java2d.opengl=true -Dsun.java2d.xrender=true"

echo "Starting Bolt from: $BOLT_PATH"
cd "$BOLT_PATH"
./bolt --no-sandbox 2>&1 | tee /tmp/bolt.log
EOF

RUN chmod +x /opt/bolt/osrs-launcher.sh

RUN mkdir -p /etc/xdg/xfce4/xfconf/xfce-perchannel-xml

RUN cat > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="workspace_count" type="int" value="1"/>
    <property name="box_move" type="bool" value="false"/>
    <property name="box_resize" type="bool" value="false"/>
    <property name="click_to_focus" type="bool" value="false"/>
    <property name="focus_delay" type="int" value="0"/>
    <property name="focus_hint" type="bool" value="false"/>
    <property name="focus_new" type="bool" value="true"/>
    <property name="raise_delay" type="int" value="0"/>
    <property name="raise_on_click" type="bool" value="false"/>
    <property name="raise_on_focus" type="bool" value="true"/>
    <property name="raise_with_any_button" type="bool" value="false"/>
    <property name="repeat_urgent_blink" type="bool" value="false"/>
    <property name="snap_to_border" type="bool" value="false"/>
    <property name="snap_to_windows" type="bool" value="false"/>
    <property name="snap_width" type="int" value="0"/>
    <property name="theme" type="string" value="Default"/>
    <property name="title_alignment" type="string" value="left"/>
    <property name="title_font" type="string" value="Sans Bold 9"/>
    <property name="title_horizontal_offset" type="int" value="0"/>
    <property name="title_shadow_active" type="string" value="false"/>
    <property name="title_shadow_inactive" type="string" value="false"/>
    <property name="title_vertical_offset_active" type="int" value="0"/>
    <property name="title_vertical_offset_inactive" type="int" value="0"/>
    <property name="urgent_blink" type="bool" value="false"/>
    <property name="use_compositing" type="bool" value="false"/>
    <property name="zoom_desktop" type="bool" value="false"/>
  </property>
</channel>
EOF

RUN cat > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="empty">
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=12;x=683;y=744"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="size" type="uint" value="30"/>
      <property name="icon-size" type="uint" value="16"/>
      <property name="autohide" type="bool" value="true"/>
      <property name="mode" type="uint" value="0"/>
    </property>
  </property>
</channel>
EOF

RUN cat > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="0"/>
          <property name="last-image" type="string" value=""/>
          <property name="last-single-image" type="string" value=""/>
          <property name="rgba1" type="array">
            <value type="double" value="0.0"/>
            <value type="double" value="0.0"/>
            <value type="double" value="0.0"/>
            <value type="double" value="1.0"/>
          </property>
        </property>
      </property>
    </property>
  </property>
  <property name="desktop-icons" type="empty">
    <property name="style" type="int" value="0"/>
    <property name="icon-size" type="uint" value="32"/>
    <property name="show-thumbnails" type="bool" value="false"/>
    <property name="show-tooltips" type="bool" value="false"/>
  </property>
</channel>
EOF

RUN mkdir -p /etc/xdg/autostart
RUN cat > /etc/xdg/autostart/osrs-app.desktop << 'EOF'
[Desktop Entry]
Name=Old School RuneScape
Comment=Launch OSRS via Bolt Launcher
Exec=/opt/bolt/osrs-launcher.sh
Terminal=false
Type=Application
Categories=Game;
StartupNotify=false
EOF

RUN chmod 644 /etc/xdg/autostart/osrs-app.desktop

RUN echo '#!/bin/bash' > $STARTUPDIR/custom_startup.sh \
    && echo '/usr/bin/desktop_ready' >> $STARTUPDIR/custom_startup.sh \
    && echo 'export LIBGL_ALWAYS_SOFTWARE=0' >> $STARTUPDIR/custom_startup.sh \
    && echo 'export LIBGL_ALWAYS_INDIRECT=0' >> $STARTUPDIR/custom_startup.sh \
    && echo 'export MESA_GL_VERSION_OVERRIDE=3.3' >> $STARTUPDIR/custom_startup.sh \
    && echo 'export MESA_GLSL_VERSION_OVERRIDE=330' >> $STARTUPDIR/custom_startup.sh \
    && echo 'xset -dpms s off s noblank &' >> $STARTUPDIR/custom_startup.sh \
    && echo 'unclutter -display :1 -idle 3 -root &' >> $STARTUPDIR/custom_startup.sh \
    && chmod +x $STARTUPDIR/custom_startup.sh

RUN chown 1000:0 $HOME && $STARTUPDIR/set_user_permission.sh $HOME
ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME
USER 1000