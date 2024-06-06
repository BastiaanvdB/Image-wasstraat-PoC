FROM debian:stable-slim

RUN apt-get update && apt-get install -y ca-certificates

RUN mkdir -p /home/clairctl

WORKDIR /home/clairctl/

COPY bin/clairctl /usr/local/bin/clairctl

RUN chmod +x /usr/local/bin/clairctl

EXPOSE 44480

ENTRYPOINT ["clairctl"]

# Default parameters
CMD ["--help"]