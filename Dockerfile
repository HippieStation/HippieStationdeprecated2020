FROM tgstation/byond:512.1427 as base
#above version must be the same as the one in dependencies.sh

FROM base as build_base

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
<<<<<<< HEAD
=======
    ca-certificates

FROM build_base as rust_g

WORKDIR /rust_g

RUN apt-get install -y --no-install-recommends \
>>>>>>> c20be496a8... Adds deploy script. CI artifacts. Dependencies file (#39040)
    libssl-dev \
    ca-certificates \
    rustc \
    cargo \
    pkg-config \
    && git init \
    && git remote add origin https://github.com/tgstation/rust-g

COPY dependencies.sh .

RUN /bin/bash -c "source dependencies.sh \
    && git fetch --depth 1 origin \$RUST_G_VERSION" \
    && git checkout FETCH_HEAD \
    && cargo build --release

<<<<<<< HEAD
=======
FROM build_base as bsql

WORKDIR /bsql

RUN apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    cmake \
    make \
    g++-7 \
    libmariadb-client-lgpl-dev \
    && git init \
    && git remote add origin https://github.com/tgstation/BSQL 

COPY dependencies.sh .

RUN /bin/bash -c "source dependencies.sh \
    && git fetch --depth 1 origin \$BSQL_VERSION" \
    && git checkout FETCH_HEAD

WORKDIR /bsql/artifacts

ENV CC=gcc-7 CXX=g++-7

RUN ln -s /usr/include/mariadb /usr/include/mysql \
    && ln -s /usr/lib/i386-linux-gnu /root/MariaDB \
    && cmake .. \
    && make

>>>>>>> c20be496a8... Adds deploy script. CI artifacts. Dependencies file (#39040)
FROM base as dm_base

WORKDIR /tgstation

FROM dm_base as build

COPY . .

RUN DreamMaker -max_errors 0 tgstation.dme && tools/deploy.sh /deploy

FROM dm_base

EXPOSE 1337

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    mariadb-client \
    libssl1.0.0 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.byond/bin

<<<<<<< HEAD
COPY --from=rustg /rust_g/target/release/librust_g.so /root/.byond/bin/rust_g
=======
COPY --from=rust_g /rust_g/target/release/librust_g.so /root/.byond/bin/rust_g
COPY --from=bsql /bsql/artifacts/src/BSQL/libBSQL.so ./
>>>>>>> c20be496a8... Adds deploy script. CI artifacts. Dependencies file (#39040)
COPY --from=build /deploy ./

VOLUME [ "/tgstation/config", "/tgstation/data" ]

ENTRYPOINT [ "DreamDaemon", "tgstation.dmb", "-port", "1337", "-trusted", "-close", "-verbose" ]
