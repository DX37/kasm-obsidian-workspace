FROM kasmweb/core-ubuntu-focal:1.15.0
#FROM kasmweb/core-ubuntu-jammy:1.15.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########


# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/backgrounds/bg_kasm.png /usr/share/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

RUN RELEASE_VERSION=$(wget -qO - "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest" | grep -Po '"tag_name": ?"v\K.*?(?=")') \
    && wget https://github.com/obsidianmd/obsidian-releases/releases/download/v${RELEASE_VERSION}/obsidian_${RELEASE_VERSION}_amd64.deb \
    && apt update \
    && apt install -y ./obsidian_${RELEASE_VERSION}_amd64.deb

COPY ./custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh


######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
