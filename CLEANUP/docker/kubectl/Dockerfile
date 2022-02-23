FROM alpine:3.13

ENV LANG=C.UTF-8

RUN apk update && apk add --no-cache curl tar gzip bash ca-certificates git gawk && rm -rf /var/cache/apk/*

RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

RUN chmod +x /usr/bin/kubectl

CMD [ "kubectl" ]
