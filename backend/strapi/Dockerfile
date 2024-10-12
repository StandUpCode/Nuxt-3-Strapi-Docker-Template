# Use an official Node.js image as the base
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the package.json and yarn.lock (or package-lock.json) to install dependencies
COPY package*.json ./

# Install the necessary dependencies
RUN npm install

# Copy the rest of the Strapi application code into the working directory
COPY . .

# Expose the default Strapi port
EXPOSE 1337

# Define environment variables for SQLite
ENV DATABASE_CLIENT=sqlite
ENV DATABASE_FILENAME=./data.db
ENV NUXT_PUBLIC_EXAMPLE_ENV=$NUXT_PUBLIC_EXAMPLE_ENV

# Create the necessary directories for SQLite
RUN mkdir -p ./data

# Build the Strapi admin panel
RUN npm run build

# Start the Strapi application
CMD ["npm", "run", "develop"]
