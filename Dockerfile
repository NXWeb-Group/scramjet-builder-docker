FROM rust:latest

WORKDIR /app

ENV NODE_VERSION=22.14.0
ENV BINARYEN_VERSION=123

RUN wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz && \
    tar -xf node-v${NODE_VERSION}-linux-x64.tar.xz && \
    ln -s /app/node-v${NODE_VERSION}-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /app/node-v${NODE_VERSION}-linux-x64/bin/npm /usr/local/bin/npm && \
    rm node-v${NODE_VERSION}-linux-x64.tar.xz

RUN wget https://github.com/WebAssembly/binaryen/releases/download/version_${BINARYEN_VERSION}/binaryen-version_${BINARYEN_VERSION}-x86_64-linux.tar.gz && \
    tar -xzf binaryen-version_${BINARYEN_VERSION}-x86_64-linux.tar.gz && \
    cp binaryen-version_${BINARYEN_VERSION}/bin/wasm-opt /usr/local/bin/ && \
    rm -rf binaryen-version_${BINARYEN_VERSION} binaryen-version_${BINARYEN_VERSION}-x86_64-linux.tar.gz


RUN cargo install --git https://github.com/r58Playz/wasm-snip.git
RUN cargo install wasm-bindgen-cli


RUN git clone --recursive https://github.com/MercuryWorkshop/scramjet.git

WORKDIR /app/scramjet

RUN npm install
RUN npm run rewriter:build && npm run build

VOLUME /app/output

CMD cp -r /app/scramjet/dist/* /app/output/