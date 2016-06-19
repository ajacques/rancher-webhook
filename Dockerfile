FROM ubuntu:16.04

ADD . /ruby-app
WORKDIR /ruby-app
RUN /usr/bin/apt-get update \
   && /usr/bin/apt-get install --no-install-recommends -qy ruby ruby-dev make g++ lib1g-dev  libghc-zlib-dev && gem install bundler --no-ri --no-rdoc \
   && /usr/bin/env bundle install --without test assets development \
   && /usr/bin/apt-get -qy purge zlib1g-dev libghc-zlib-dev libpq-dev ruby-dev g++ make patch \
   && /usr/bin/apt-get -qy autoremove \
   && /bin/rm -rf /var/lib/gems/2.3.0/cache /var/cache/* /var/lib/apt/lists/* \
   && find . -type f -print -exec chmod 444 {} \; && find . -type d -print -exec chmod 555 {} \; \
   && chown www-data:www-data db && chown -R www-data:www-data tmp \
   && chmod 755 db && find tmp -type d -print -exec chmod 755 {} \; \
   && find bin -type f -print -exec chmod 544 {} \;
USER www-data
EXPOSE 8080
ENTRYPOINT ["/usr/bin/ruby", "/ruby-app/bin/bundle", "exec"]
CMD ["/usr/local/bin/unicorn", "-o", "0.0.0.0", "-p", "8080", "-c", "unicorn.rb"]
