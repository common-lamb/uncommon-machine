# 00 base os pull, locale, os update
FROM docker.io/jas4711/debian-with-guix:stable AS stage00
COPY --chmod=770 00.sh /opt/
RUN /opt/00.sh

# 01 guix I test daemon
FROM stage00 AS stage01
COPY --chmod=770 01.sh /opt/
RUN /opt/01.sh

# 02 guix II, daemon start, dependencies
FROM stage01 AS stage02
COPY --chmod=770 02.sh /opt/
RUN /opt/02.sh

# 03 security encryption dotfiles secrets
FROM stage02 AS stage03
COPY --chmod=770 03.sh /opt/
RUN /opt/03.sh

# 04 emacs, emacs supporting packages, spacemacs
FROM stage03 AS stage04
COPY --chmod=770 04.sh /opt/
RUN /opt/04.sh

# 05 terminal
FROM stage04 AS stage05
COPY --chmod=770 05.sh /opt/
RUN /opt/05.sh

# 06 workflows, disposable environments, data languages and containers,
FROM stage05 AS stage06
COPY --chmod=770 06.sh /opt/
RUN /opt/06.sh

# 07 lisp I, SBCL, quicklisp, ultralisp, ocicl, shl
FROM stage06 AS stage07
COPY --chmod=770 07.sh /opt/
RUN /opt/07.sh

# 08 lisp II Lish, lem, nyxt, stumpw
FROM stage07 AS stage08
COPY --chmod=770 08.sh /opt/
RUN /opt/08.sh

# 09 network
FROM stage08 AS stage09
COPY --chmod=770 09.sh /opt/
RUN /opt/09.sh

# 10 data storage redundancy and access
FROM stage09 AS stage10
COPY --chmod=770 10.sh /opt/
RUN /opt/10.sh

# 11 graphics and styling
FROM stage10 AS stage11
COPY --chmod=770 11.sh /opt/
RUN /opt/11.sh

# 12 agents and models
FROM stage11 AS stage12
COPY --chmod=770 12.sh /opt/
RUN /opt/12.sh

# 99 patches
FROM stage12 AS stage99
COPY --chmod=770 99.sh /opt/
RUN /opt/99.sh

# FROM stageN AS stageN
# COPY --chmod=770 N.sh /opt/
# RUN /opt/N.sh
