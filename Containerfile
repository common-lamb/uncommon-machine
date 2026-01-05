# 00 base system
FROM docker.io/jas4711/debian-with-guix:stable AS stage00
COPY --chmod=770 00.sh /opt/
RUN /opt/00.sh

# 01 guix I
FROM stage00 AS stage01
COPY --chmod=770 01.sh /opt/
RUN /opt/01.sh

# 02 guix II
FROM stage01 AS stage02
COPY --chmod=770 02.sh /opt/
RUN /opt/02.sh

# 03 security
FROM stage02 AS stage03
COPY --chmod=770 03.sh /opt/
RUN /opt/03.sh

# 04 emacs
FROM stage03 AS stage04
COPY --chmod=770 04.sh /opt/
RUN /opt/04.sh

# 05 terminal
FROM stage04 AS stage05
COPY --chmod=770 05.sh /opt/
RUN /opt/05.sh

# 06 workflows
FROM stage05 AS stage06
COPY --chmod=770 06.sh /opt/
RUN /opt/06.sh

# 07 lisp I
FROM stage06 AS stage07
COPY --chmod=770 07.sh /opt/
RUN /opt/07.sh

# 08 lisp II
FROM stage07 AS stage08
COPY --chmod=770 08.sh /opt/
RUN /opt/08.sh

# 09 &&& network
FROM stage08 AS stage09
COPY --chmod=770 09.sh /opt/
RUN /opt/09.sh

# 10 &&& data
FROM stage09 AS stage10
COPY --chmod=770 10.sh /opt/
RUN /opt/10.sh

# 11 &&& style




FROM stage00 AS stage00
COPY --chmod=770 00.sh /opt/
RUN /opt/00.sh
