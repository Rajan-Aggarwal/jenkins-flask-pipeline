FROM nginx:mainline-alpine

# Install python and pip

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then  \
    	ln -s pip3 /usr/bin/pip ; \
    fi && \
    if [[ ! -e /usr/bin/python ]]; then \
    	ln -sf /usr/bin/python3 /usr/bin/python; \
    fi && \
    rm -r /root/.cache

# Setup the working directory

WORKDIR /usr/src/app

# Install requirements

ADD . .
## skip in case of failures
RUN cat app/requirements.pip | xargs -n 1 pip install

# Nginx configurations

COPY config/nginx/nginx.conf /etc/nginx/
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
RUN chgrp -R root /var/cache/nginx
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
RUN addgroup nginx root

# Expose a port

EXPOSE 8081

# Bind with gunicorn

CMD gunicorn --bind 0.0.0.0:5000 wsgi --chdir /usr/src/app/app & nginx -g "daemon off;"
