# Docker
docker pull ruby:3.0.2
docker build -t alpha-blog-app .
docker run -p 3002:3000 alpha-blog-app
# dump DB
docker cp <container id>:/app/db/development.sqlite3 /Users/andreykuluev/Documents/Courses.nosync/ruby-on-rails-lessons/udemy/ruby_on_rails_6/alpha-blog/db/development.sqlite3


# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
