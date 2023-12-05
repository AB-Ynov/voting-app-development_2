# Stage 1: Build
FROM node:14 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Stage 2: Production Image
FROM nginx:1.21.3-alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
