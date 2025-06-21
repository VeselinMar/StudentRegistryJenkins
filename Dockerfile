FROM node:14

# Install Docker CLI & docker-compose (legacy)
USER root

RUN apt-get update && \
    apt-get install -y curl apt-transport-https ca-certificates gnupg lsb-release software-properties-common

# Add Docker GPG and CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y docker-ce-cli

# Install docker-compose (LEGACY binary — this is what Jenkins needs!)
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Set the working directory
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3030

CMD [ "npm", "start" ]
