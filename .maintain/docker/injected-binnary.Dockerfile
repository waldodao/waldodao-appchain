FROM ubuntu:20.04
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
		libssl1.1 \
		ca-certificates && \
  # apt cleanup
    apt-get autoremove -y && \
    apt-get clean && \
    find /var/lib/apt/lists/ -type f -not -name lock -delete; \
  # Create user and set ownership and permissions as required
  useradd -m -u 1001 -U -s /bin/sh -d /home/waldodao-appchain waldodao-appchain && \
  # manage folder data
  mkdir -p /home/waldodao-appchain/.local/share && \
  mkdir /data && \
  chown -R waldodao-appchain:waldodao-appchain /data && \
  ln -s /data /home/waldodao-appchain/.local/share/waldodao-appchain
# Add binnary to docker image
COPY ./waldodao-appchain /usr/local/bin
# Set to a non-root built-in user
USER waldodao-appchain
# Set environment variable
ENV RUST_BACKTRACE=1
EXPOSE 30333 9933 9944 9615
VOLUME ["/data"]
ENTRYPOINT ["/usr/local/bin/waldodao-appchain"]
