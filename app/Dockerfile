# ---------- builder (optional, keeps layers tidy) ----------
  
FROM alpine:3.20 AS builder
WORKDIR /work
COPY site ./site

# ---------- runtime ----------

FROM nginx:1.27-alpine

COPY --from=builder /work/site /usr/share/nginx/html

RUN printf 'server { \
  listen 80; listen [::]:80; \
  root /usr/share/nginx/html; index index.html; \
  location ~* \\.(js|css|png|jpg|jpeg|gif|svg|woff2?)$ { expires 7d; add_header Cache-Control "public"; } \
  location / { try_files $uri /index.html; } \
}\n' > /etc/nginx/conf.d/default.conf
EXPOSE 80