FROM kasmweb/core-ubuntu-jammy:1.17.0

USER root
ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jre \
    openjdk-11-jre-headless \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    libegl1-mesa \
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
    libasound2 \
    pulseaudio-utils \
    unclutter \
    xdotool \
    wmctrl \
    fonts-dejavu-core \
    fontconfig \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'deadline' > /sys/block/*/queue/scheduler 2>/dev/null || true

RUN mkdir -p /opt/runelite \
    && wget -O /opt/runelite/RuneLite.jar \
       https://github.com/runelite/launcher/releases/latest/download/RuneLite.jar

RUN cat > /opt/runelite/runelite-fullscreen.sh << 'EOF'
#!/bin/bash
export DISPLAY=:1
export _JAVA_OPTIONS="-Xms512m -Xmx4096m -XX:+UseG1GC -XX:MaxGCPauseMillis=25 -Dsun.java2d.opengl=true -Dsun.java2d.xrender=true -server"

sleep 3
java -jar /opt/runelite/RuneLite.jar &
RUNELITE_PID=$!

sleep 4
for i in {1..5}; do
    WINDOW_ID=$(wmctrl -l | grep -i "runelite\|oldschool" | head -1 | awk '{print $1}')
    if [ ! -z "$WINDOW_ID" ]; then
        wmctrl -i -r "$WINDOW_ID" -b add,fullscreen
        break
    fi
    sleep 1
done

wait $RUNELITE_PID
EOF

RUN chmod +x /opt/runelite/runelite-fullscreen.sh

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

RUN cat > /etc/xdg/autostart/runelite-autostart.desktop << 'EOF'
[Desktop Entry]
Name=RuneLite
Comment=Auto-launch RuneLite in fullscreen
Exec=/opt/runelite/runelite-fullscreen.sh
Terminal=false
Type=Application
Categories=Game;
EOF

RUN chmod 644 /etc/xdg/autostart/runelite-autostart.desktop

RUN echo "[Desktop Entry]" > $HOME/Desktop/RuneLite.desktop \
    && echo "Version=1.0" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Type=Application" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Name=RuneLite Fullscreen" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Comment=OSRS RuneLite Client (Performance Optimized)" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Exec=/opt/runelite/runelite-fullscreen.sh" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Icon=applications-games" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Terminal=false" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Categories=Game;" >> $HOME/Desktop/RuneLite.desktop \
    && chmod +x $HOME/Desktop/RuneLite.desktop

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