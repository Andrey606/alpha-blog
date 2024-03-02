# Use the official Ruby image with version 3.0.2 as the base image
FROM ruby:3.0.2

# Set the working directory inside the container
WORKDIR /app

# Install dependencies
RUN gem install rails -v '6.1.4' --no-document

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Expose port 3000 to the outside world
EXPOSE 3000

# Command to start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
