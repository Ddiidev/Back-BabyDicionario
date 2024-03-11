# Use uma imagem base que tenha o ambiente necessário para executar o seu executável
FROM ubuntu:latest

WORKDIR /usr/local/bin

COPY dicionario_do_bebe .
COPY src/assets src/assets

RUN apt-get update && apt-get install -y \
libatomic1 \
 libssl-dev \
 libsqlite3-dev
#  libpq-dev \
#  postgresql-server-dev-all \

EXPOSE 3035

CMD ["./dicionario_do_bebe"]
