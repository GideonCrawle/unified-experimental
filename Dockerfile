FROM jakkn/nwnxee-builder as builder
WORKDIR /nwnx
COPY ./ .
WORKDIR /nwnx/build
# compile nwnx
RUN CC="gcc -m32" CXX="g++ -m32" cmake .. && make

FROM beamdog/nwserver
RUN mkdir /nwn/nwnx
COPY --from=builder /nwnx/Binaries/* /nwn/nwnx/
# Install plugin run dependencies
RUN mkdir -p /usr/share/man/man1
RUN apt-get update \
    && apt-get -y install --no-install-recommends openjdk-8-jdk-headless libssl1.1 \
    && rm -r /var/cache/apt /var/lib/apt/lists
# Configure nwserver to run with nwnx 
ENV NWNX_CORE_LOAD_PATH=/nwn/nwnx/
ENV NWN_LD_PRELOAD="/nwn/nwnx/NWNX_Core.so"
# Use NWNX_ServerLogRedirector as default log manager
ENV NWNX_SERVERLOGREDIRECTOR_SKIP=n \
    NWN_TAIL_LOGS=n \
    NWNX_CORE_LOG_LEVEL=7 \
    NWNX_SERVERLOGREDIRECTOR_LOG_LEVEL=6
# Disable all other plugins by default. Remember to add new plugins to this list.
ENV NWNX_ADMINISTRATION_SKIP=y \
    NWNX_BEHAVIOURTREE_SKIP=y \
    NWNX_CHAT_SKIP=y \
    NWNX_CREATURE_SKIP=y \
    NWNX_DATA_SKIP=y \
    NWNX_EVENTS_SKIP=y \
    NWNX_ITEM_SKIP=y \
    NWNX_JVM_SKIP=y \
    NWNX_METRICS_INFLUXDB_SKIP=y \
    NWNX_OBJECT_SKIP=y \
    NWNX_PLAYER_SKIP=y \
    NWNX_PROFILER_SKIP=y \
    NWNX_REDIS_SKIP=y \
    NWNX_RUBY_SKIP=y \
    NWNX_SQL_SKIP=y \
    NWNX_THREADWATCHDOG_SKIP=y \
    NWNX_TIME_SKIP=y \
    NWNX_TRACKING_SKIP=y \
    NWNX_TWEAKS_SKIP=y \
    NWNX_WEAPON_SKIP=y
