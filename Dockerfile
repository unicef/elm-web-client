FROM node:11.0.0

WORKDIR /app

# Move package file to the temp forlder
ADD package.json /tmp
# Install dependencies.
RUN cd /tmp && npm install -y
# Move the dependency directory back to the app.
RUN mv /tmp/node_modules /app
# Installing ELM 0.18
RUN npm i -g  elm@0.18.0 --unsafe-perm=true --allow-root
# Copy contents of current folder including source files to the container folder
COPY . /app
# Installing ELM packages
RUN cd /app && elm-package install --yes
## Run the development server
CMD if [ ${APP_ENV} = production ]; \
	then \
	npm run build && \
  node server.js; \
	else \
	npm run client-dev-ssl; \
	fi

# CMD npm run client-dev-ssl
# Expose port
EXPOSE 8888
