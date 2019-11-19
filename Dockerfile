######################
# Stage: Builder
FROM ruby:2.6.5-alpine as Builder

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV SECRET_KEY_BASE=ignore
ENV RAILS_SERVE_STATIC_FILES=true

RUN apk add --update --no-cache \
    build-base \
    nano \
    git \
    mysql-client \
    mariadb-dev \
    imagemagick \
    nodejs \
    yarn \
    tzdata

WORKDIR /app

# Install gems
ADD Gemfile* /app/
RUN bundle config --global frozen 1 \
 && bundle install -j4 --retry 3 \
 # Remove unneeded files (cached *.gem, *.o, *.c)
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

# Install yarn packages
COPY package.json yarn.lock .yarnclean /app/
RUN yarn install --check-files

# Add the Rails app
ADD . /app

# Precompile assets
RUN rails assets:precompile; exit 0
RUN rails assets:precompile

###############################
# Stage Final
FROM ruby:2.6.5-alpine as Final

# Add Alpine packages
RUN apk add --update --no-cache \
    mysql-client \
    imagemagick \
    nano \
    tzdata \
    file

# Add user
RUN addgroup -g 1000 -S app \
 && adduser -u 1000 -S app -G app
USER app

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app /app /app

# Set Rails env
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

WORKDIR /app

# Expose Puma port
EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME