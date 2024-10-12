# 1. Use an official Node.js runtime as a parent image
FROM node:18-alpine

# 2. Set the working directory in the container
WORKDIR /app

# 3. Copy the package.json and package-lock.json (if you use it)
COPY package*.json ./

# 4. Install dependencies
RUN npm install

# 5. Copy the rest of your application code
COPY . .

# 6. Build the application
RUN npm run build

# 7. Expose the port that your app will run on
EXPOSE 3000

# 8. Set environment variables for production
ENV NODE_ENV=production

# 9. Start the app in SSR mode
CMD ["npm", "run", "start"]
# 1. Use an official Node.js runtime as a parent image
FROM node:18-alpine

# 2. Set the working directory in the container
WORKDIR /app

# 3. Copy the package.json and package-lock.json (if you use it)
COPY package*.json ./

# 4. Install dependencies
RUN npm install

# 5. Copy the rest of your application code
COPY . .

# 6. Build the application
RUN npm run build

# 7. Expose the port that your app will run on
EXPOSE 3000

# 8. Set environment variables for production
ENV NODE_ENV=production

# 9. Start the app in SSR mode
CMD ["npm", "run", "start"]
