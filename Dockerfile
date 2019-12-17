FROM ruby:2.6.5

WORKDIR /sample_app
COPY . .
RUN bundle install
CMD ["ruby",  "ruby_docker.rb"]
