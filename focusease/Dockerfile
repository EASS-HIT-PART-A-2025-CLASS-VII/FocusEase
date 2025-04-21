# Use the official Flutter image
FROM dart:stable as build

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter \
    && /flutter/bin/flutter doctor

# Set flutter to PATH
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter config --enable-web

# Copy project files
WORKDIR /app
COPY . .

# Get dependencies
RUN flutter pub get

# Build web
RUN flutter build web

# Serve with a simple server
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80
