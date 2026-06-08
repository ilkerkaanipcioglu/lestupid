# Build stage
FROM node:20-alpine AS build
WORKDIR /app
ARG VITE_LESTUPID_API_BASE_URL
ARG VITE_OPPORTUNITY_ADAPTER
ENV VITE_LESTUPID_API_BASE_URL=$VITE_LESTUPID_API_BASE_URL
ENV VITE_OPPORTUNITY_ADAPTER=$VITE_OPPORTUNITY_ADAPTER
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
