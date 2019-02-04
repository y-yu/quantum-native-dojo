FROM jupyter/base-notebook:latest

LABEL maintainer="Yoshimura Yuu <yyu at mental.poker>"

USER root

ENV TEXLIVE_DEPS \
    xz-utils \
    fontconfig
    
ENV TEXLIVE_PATH /usr/local/texlive

ENV FONT_DEPS \
    unzip \
    fontconfig

ENV FONT_PATH /usr/share/fonts/

ENV PERSISTENT_DEPS \
    wget \
    make \
    perl \
    ghostscript \
    bash \
    git \
    libpam-modules \
    libpam-modules-bin \
    libpam-runtime \
    libpam-systemd

ENV PATH $TEXLIVE_PATH/bin/x86_64-linux:$PATH

# Initialize
RUN apt-get update && \
    apt-get -yq dist-upgrade && \
    apt-get install -yq --no-install-recommends apt-utils

# Install basic dependencies
RUN apt-get install -yq --no-install-recommends $PERSISTENT_DEPS

# Setup fonts
RUN mkdir -p $FONT_PATH && \
    apt-get install -yq --no-install-recommends $FONT_DEPS && \
    wget https://github.com/adobe-fonts/source-han-sans/raw/release/SubsetOTF/SourceHanSansJP.zip && \
      unzip SourceHanSansJP.zip && \
      cp SourceHanSansJP/*.otf $FONT_PATH && \
      rm -rf SourceHanSansJP.zip SourceHanSansJP && \
    wget https://github.com/adobe-fonts/source-han-serif/raw/release/SubsetOTF/SourceHanSerifJP.zip && \
      unzip SourceHanSerifJP.zip && \
      cp SourceHanSerifJP/*.otf $FONT_PATH && \
      rm -rf SourceHanSerifJP.zip SourceHanSerifJP && \
    fc-cache -f -v && \
    apt-get remove -yq $FONT_DEPS

# Install TeXLive
RUN apt-get install -yq --no-install-recommends $TEXLIVE_DEPS && \
    mkdir /tmp/install-tl-unx && \
    wget -qO- http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
      tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    printf "%s\n" \
      "TEXDIR $TEXLIVE_PATH" \
      "selected_scheme scheme-small" \
      "option_doc 0" \
      "option_src 0" \
      > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
      -profile /tmp/install-tl-unx/texlive.profile && \
    tlmgr install latexmk collection-luatex collection-langjapanese \
      collection-fontsrecommended type1cm mdframed needspace fontaxes \
      boondox everyhook svn-prov framed placeins adjustbox subfiles \
      collectbox fncychap sourcesanspro sourceserifpro cm-unicode && \
    luaotfload-tool -u -vvv && \
    apt-get remove -yq $TEXLIVE_DEPS

# Clean up
RUN apt-get remove -yq apt-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/workdir"]

WORKDIR /workdir

ENTRYPOINT ["/bin/bash", "-c", "make"]
