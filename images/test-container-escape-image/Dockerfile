FROM alpine:latest

RUN apk add --no-cache bash curl shadow

COPY test-falcon.sh /test-falcon.sh

RUN chmod +x /test-falcon.sh

# Set the entrypoint to run the script
ENTRYPOINT ["/test-falcon.sh"]
