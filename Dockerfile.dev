FROM elixir:1.13-alpine

# Install build dependencies
RUN apk add --no-cache build-base git python3

# Install frontend dependencies
RUN apk add --no-cache nodejs npm
RUN npm install -g npx

# Install pdf generation dependencies
RUN apk add --no-cache \
    libgcc libstdc++ libx11 glib libxrender libxext libintl \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation
COPY --from=madnight/alpine-wkhtmltopdf-builder:0.12.5-alpine3.10-606718795 \
    /bin/wkhtmltopdf /bin/wkhtmltopdf

# Install imagemagick dependencies
RUN apk add --no-cache file imagemagick

# Install development dependencies
RUN apk add --no-cache inotify-tools

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app

CMD [ "sh", "-c", "mix setup; mix phx.server" ]
