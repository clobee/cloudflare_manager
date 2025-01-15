# Start from the official Terraform image
FROM hashicorp/terraform:1.9

RUN apk add --no-cache \
    curl \
    tar \
    gzip \
    coreutils \
    libc6-compat

# Install dependencies and cf-terraforming
RUN curl -L https://github.com/cloudflare/cf-terraforming/releases/download/v0.21.0/cf-terraforming_0.21.0_linux_amd64.tar.gz \
    -o cf-terraforming_0.21.0_linux_amd64.tar.gz \
    && tar -xzf cf-terraforming_0.21.0_linux_amd64.tar.gz \
    && mv cf-terraforming /usr/local/bin/ \
    && chmod +x /usr/local/bin/cf-terraforming \
    && rm -f cf-terraforming_0.21.0_linux_amd64.tar

