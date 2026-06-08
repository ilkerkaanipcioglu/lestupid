FROM elixir:1.16-alpine

# Sistem bağımlılıklarını kur
RUN apk add --update --no-cache \
    build-base \
    git \
    nodejs \
    npm \
    postgresql-client \
    inotify-tools \
    tzdata

# Çalışma dizinini ayarla
WORKDIR /app

# Gerekli araçları kur
RUN mix local.hex --force && \
    mix local.rebar --force

# Phoenix 1.7 için Node.js bağımlılıklarını kur
RUN npm install -g esbuild

# Tüm Mix bağımlılıklarını kopyala ve kur
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

# Diğer tüm proje dosyalarını kopyala
COPY . .

# Dev ortamı için tüm bağımlılıkları kur
RUN mix deps.get
RUN cd assets && npm install

# Erişim noktasını belirle
EXPOSE 4003

# Entrypoint
CMD ["mix", "phx.server"]
