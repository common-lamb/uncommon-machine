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

# 04
FROM stage03 AS stage04
COPY --chmod=770 04.sh /opt/
RUN /opt/04.sh
