# ---- Build stage ----
FROM node:14-bullseye AS build

WORKDIR /app

# Install build tools for node-gyp
RUN apt-get update \
    && apt-get install -y python make g++ bash \
    && rm -rf /var/lib/apt/lists/*

# Use Yarn v1 (classic)
RUN corepack enable \
    && corepack prepare yarn@1.22.22 --activate

# Copy dependency files first
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --non-interactive --ignore-engines

# Copy the source code
COPY . .

# Build app
RUN yarn build

# ---- Runtime stage ----
FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
