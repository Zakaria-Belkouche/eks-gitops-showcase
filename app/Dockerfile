# ------- builder stage (no toolchain; just a clean copy) -------
FROM alpine:3.20 AS builder
WORKDIR /build
COPY site/ ./
# (optional) do any pre-processing here if you want later

# ------- runtime stage (serve via NGINX) -------
FROM nginx:1.27-alpine
# minimal, secure-ish config
COPY nginx.conf /etc/nginx/conf.d/default.conf
# bring in the site from the builder image
COPY --from=builder /build /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK CMD wget -qO- http://localhost/ >/dev/null 2>&1 || exit 1