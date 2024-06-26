# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.3
FROM registry.hub.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

# 共通環境変数設定
ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test" \
    PATH="/usr/local/bundle/bin:/rails/bin:$PATH"

# ビルドステージ
FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config libmariadb-dev libmariadb3 default-mysql-client dos2unix curl nodejs

# Add nvm and Yarn
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 18 && \
    nvm use 18 && \
    npm install -g yarn

# Bundlerインストール
RUN gem install bundler -v '~> 2.5'

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile
COPY . .

# ここで実行権限を追加
RUN chmod +x ./bin/rails

RUN bundle exec bootsnap precompile app/ lib/

RUN find bin -type f -exec dos2unix {} + && sed -i 's/ruby.exe$/ruby/' bin/*

# ここで環境変数を設定
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION
ARG AWS_BUCKET

ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    AWS_REGION=$AWS_REGION \
    AWS_BUCKET=$AWS_BUCKET

RUN ./bin/rails assets:precompile

# 本番環境ステージ
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0 libvips libmariadb3 default-mysql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

ENV PATH="/usr/local/bundle/bin:/rails/bin:$PATH"

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
COPY bin/docker-entrypoint /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

USER rails:rails
ENTRYPOINT ["docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
