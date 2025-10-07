# syntax = docker/dockerfile:1

# Docker Hubの429回避のため、AWS Public ECRミラーを使用
FROM public.ecr.aws/docker/library/ruby:3.2.6-slim AS base

# Rails app lives here
WORKDIR /rails

# Production向けのBundler設定
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# ===== Build stage =====
FROM base AS build

# gemビルドに必要なパッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config libpq-dev libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# lockfileに合わせてbundlerを揃える
RUN gem install bundler -v 2.4.19

# gemsをインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# アプリ本体
COPY . .

# bootsnap precompile
RUN bundle exec bootsnap precompile app/ lib/

# アセットプリコンパイル（マスターキー不要で走らせる）
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ===== Runtime stage =====
FROM base

# 本番に必要な最低限のパッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ビルド成果物をコピー
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# 非rootで実行
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# DB準備＆起動
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
