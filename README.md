# Rails API Project

This is a Rails API project that provides various features such as user authentication using JWT, and includes RSpec for testing. It is built with Ruby 3.3.3 and Rails 7.1.3.

## Author

This project is maintained by: Augustine Sefa.

[Github Profile](https://github.com/NanaYaw)

## Getting Started

Follow these instructions to set up and run the project on your local machine.

### Prerequisites

- Ruby 3.3.3
- Rails 7.1.3
- PostgreSQL 15

### Dependency Management
- [Bundler](https://github.com/rubygems/rubygems/tree/master/bundler)
Ruby 3.3.3 comes with Bundler preinstalled by default

### Gems Used

	
	gem 'active_model_serializers'
	gem 'bcrypt'
	gem 'bootsnap', require: false
	gem 'jwt'
	gem 'pg', '~> 1.1'
	gem 'puma', '>= 5.0'
	gem 'rack-cors'
	gem 'rails', '~> 7.1.3', '>= 7.1.3.4'
	gem 'tzinfo-data', platforms: %i[windows jruby]

	group :development, :test do
	  gem 'debug', platforms: %i[mri mingw x64_mingw]
	  gem 'factory_bot_rails'
	  gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'main'
	  gem 'pry-rails'
	  gem 'rspec-rails'
	  gem 'shoulda-matchers'
	end

### Setting Up the Project

1. **Clone the repository:**
   ```sh
   git clone https://github.com/NanaYaw/focus_ecommerce.git
   cd focus_ecommerce

2. **Install Depedencies**
	```sh
	bundle install
3. **Set up the database:**
	```sh
	rails db:create
	rails db:migrate
	rails db:seed
4. **Run the server:**
	```sh
	rails server

### Running Tests
This project uses RSpec for testing. To run the tests, use the following command:

    bundle exec rspec

### Configuration

Make sure to configure your environment variables, such as database credentials and secret keys. You can use a `.env` file or any other method of your choice.


