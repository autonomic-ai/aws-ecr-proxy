FROM nginx:1.12.0-alpine

RUN apk -v --update add \
        python \
        py-pip \
        && \
    pip install --upgrade pip awscli==1.11.92 && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

ADD configs/nginx/nginx.conf /etc/nginx/nginx.conf
ADD configs/nginx/ssl /etc/nginx/ssl

ADD configs/entrypoint.sh /entrypoint.sh
ADD configs/auth_update.sh /auth_update.sh
ADD configs/renew_token.sh /renew_token.sh

RUN chmod 777 /etc/nginx
RUN chmod 666 /etc/nginx/nginx.conf

USER nginx

RUN mkdir -p /var/cache/nginx/.aws

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
