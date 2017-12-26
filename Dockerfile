FROM mhart/alpine-node:9.3

# Creates a more restricted user group on file system and 
# Install nodemon package
RUN addgroup -S nodeUser \
  && adduser -S -g nodeUser nodeUser \
  && npm install -g -D nodemon --no-optional \
  && mkdir -p /base/app \
  && wait

# Copy only package.json for cache layering advantage
COPY package.json /tmp/package.json

# Install dependencies in`package.json`,
# Clean npm cache from preveious npm installs
# Finally, copy installed modules to work directory
RUN cd /tmp \
  && npm install \
  && npm cache clean --force \
  && mv -f /tmp/node_modules /base/app

# Prevents command from being executed as sudo, for unpriviledged user
USER nodeUser

WORKDIR  /base/app
EXPOSE 3000
COPY . /base/app

CMD ["npm", "start"]
