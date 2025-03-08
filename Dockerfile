FROM archlinux/archlinux AS initial

RUN pacman --noconfirm -Syu &&\
    pacman --noconfirm -S git base-devel
RUN useradd --create-home --no-user-group abc &&\
    echo 'abc ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers
USER abc
RUN cd /tmp &&\
    git clone https://aur.archlinux.org/yay-bin.git &&\
    cd yay-bin &&\
    makepkg --noconfirm -si &&\
    cd .. && rm -rf yay-bin

RUN yay --noconfirm -S \
        supervisor alacritty \
        openbox obmenu-generator polkit \
        xf86-video-amdgpu mesa vulkan-radeon \
        noto-fonts noto-fonts-cjk noto-fonts-emoji

RUN yay --noconfirm -S pulseaudio &&\
    sudo useradd pulse

RUN yay --noconfirm -S feishu-bin
RUN yay --noconfirm -S corplink-bin &&\
    mkdir -p ~/.config/Corplink
RUN yay --noconfirm -S wemeet-bin

COPY /root /
COPY --chown=abc /config /home/abc

# clean up
RUN yes | sudo pacman -Scc &&\
    yes | yay -Scc
RUN echo '' | sudo tee /etc/sudoers


FROM scratch
COPY --from=initial / /
CMD ["/bin/bash", "/opt/scripts/init.sh"]
