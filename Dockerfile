# Use the official Apache HTTP Server image
FROM httpd:alpine

# Set the working directory
WORKDIR /usr/local/apache2/htdocs/

# Copy all files from the current directory to the working directory in the container
COPY . .

# Expose port 80
EXPOSE 80