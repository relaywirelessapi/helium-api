# Use Node.js 18 as base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm ci

# Copy the rest of the application
COPY . .

# Expose port 3000 for the Docusaurus server
EXPOSE 3000

# Build the Docusaurus site
RUN npm run build

# Use serve command for production
CMD ["npm", "run", "serve"]
