FROM kasmweb/core-ubuntu-jammy:1.17.0

USER root
ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

######### Customize Container Here ###########

# Install Java runtime with GUI support and X11 dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jre \
    fonts-dejavu-core \
    wget \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    libegl1-mesa \
    libasound2 \
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
    && rm -rf /var/lib/apt/lists/*

# Download RuneLite from official GitHub releases
RUN mkdir -p /opt/runelite \
    && wget -O /opt/runelite/RuneLite.jar \
       https://github.com/runelite/launcher/releases/latest/download/RuneLite.jar

# Create desktop integration with .desktop file and optimized Java options
RUN echo "[Desktop Entry]" > $HOME/Desktop/RuneLite.desktop \
    && echo "Version=1.0" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Type=Application" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Name=RuneLite" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Comment=Old School RuneScape Client" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Exec=env _JAVA_OPTIONS=\"-Dsun.java2d.opengl=true -Dsun.java2d.pmoffscreen=false -Dsun.java2d.xrender=true -Dsun.java2d.d3d=false -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -Xms512m -Xmx2048m\" java -jar /opt/runelite/RuneLite.jar" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Icon=applications-games" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Terminal=false" >> $HOME/Desktop/RuneLite.desktop \
    && echo "Categories=Game;" >> $HOME/Desktop/RuneLite.desktop \
    && chmod +x $HOME/Desktop/RuneLite.desktop

# Create optimized startup script with Java GUI optimizations
RUN echo '#!/bin/bash' > $STARTUPDIR/custom_startup.sh \
    && echo '/usr/bin/desktop_ready' >> $STARTUPDIR/custom_startup.sh \
    && echo 'export _JAVA_OPTIONS="-Dsun.java2d.opengl=true -Dsun.java2d.pmoffscreen=false -Dsun.java2d.xrender=true -Dsun.java2d.d3d=false -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -Xms512m -Xmx2048m"' >> $STARTUPDIR/custom_startup.sh \
    && echo 'java -jar /opt/runelite/RuneLite.jar &' >> $STARTUPDIR/custom_startup.sh \
    && chmod +x $STARTUPDIR/custom_startup.sh

######### End Customizations ###########

# Follow proper Kasm user permission model (1000:1000)
RUN chown 1000:0 $HOME && $STARTUPDIR/set_user_permission.sh $HOME
ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME
USER 1000