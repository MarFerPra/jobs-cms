# Jobs CMS in Rails
by *Marco Fernández Pranno*  

Jobs CMS API: covers basic job, contract and applications functionality.  
Provides a way to manage jobs using categories and keywords.  

*Rbenv: `1.1.0` | Ruby: `2.3.3` | Rails: `5.0.0.1`*

## Installation

With rbenv or any other Ruby version manager, install `Ruby` (>= 2.3.3), `rails` and `bundle` gems.
Once into the project's directory, type `bundle` on a terminal to install all dependencies.

Use `rake db:migrate` to configure the database.

In order to provide encryption and email functionality, it's required to create the file `/config/secrets.yml` with the following content:  
```
development:
  secret_key_base: <your-server-secret-key>
  mailgun_api_key: '<your-mailgun-api-key>'
  mailgun_domain: '<your-mailgun-mailgun-domain>'
  mailgun_receiver: '<your-mailgun-email-receiver>'

test:
  secret_key_base: <your-server-secret-key>
  mailgun_api_key: '<your-mailgun-api-key>'
  mailgun_domain: '<your-mailgun-mailgun-domain>'
  mailgun_receiver: '<your-mailgun-email-receiver>'

production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  mailgun_api_key: <%= ENV["MAILGUN_API_KEY"] %>
  mailgun_domain: <%= ENV["MAILGUN_DOMAIN"] %>
  mailgun_receiver: <%= ENV["MAILGUN_RECEIVER"] %>
```

To obtain a new server's secret key we can use the rake task:  
`bundle exec rake secret`  
This will return a secure value to use as secret key.

On the other hand, mailgun's variables are provided on [Mailgun's website](https://mailgun.com) after registration.

## Usage

`rails s`

## Test

`rspec`

**Key functionality covered:**
- Routes
- Authentication
- On get requests job elements have category, contract and keywords attributes.
- Job creation supports nested attributes for category, contract and keywords.
- Application creation sends an email as notification if job's active, otherwise returns an error message.

## API Routes

- POST `/users`: Create user
- POST `/authenticate`: Authenticate requests, requires login credentials, returns authentication token
- POST `/jobs`: Create job (supports nested attributes for contract, category and keywords)
- PUT `/jobs`: Update existing job
- GET `/jobs`: Get all existing jobs
- GET `/jobs/page`: Get all existing jobs, paginated.
- GET `/jobs/:id`: Get job
- GET `/jobs/:id/set_active`: Changes *active* attribute on job
- GET `/applications`: Get all existing applications
- GET `/applications/:id`: Get application
- POST `/applications`: Create application, requires job_id. If job's active sends an email as notification, otherwise returns an error message.

## Implementation

#### Models

**Job:** title, description, contract, category, keywords, applications.  
**Contract:** type_of, jobs.  
**Category:** title, jobs.  
**Keywords:** name, jobs.  
**Application:** name, email, cover, cv, job.  
**User:** name, email, password.

Some extra relations have been defined to extend the functionality for future features, such as having a reference to jobs on Keyword, Category and Contract; in case it's necessary to filter jobs depending on those parameters.

Defining a Contract model allows to easily extend the type of a job from 'freelance'/'fulltime' to a more detailed classification.  

Application model provides persistence to applications on jobs, in addition to sending an email to notify it's creation. Once again, this adds extensibility to the platform.  

User model is necessary for authentication system.

#### Email

Due to Mandril's new policy, I was unable to use it for the project, so I decided to use Mailgun instead.  

In order to use the email functionality, it's necessary to add some environment variables, such as `mailgun_api_key`, `mailgun_domain` and `mailgun_receiver`.  
Those variables can be defined on `/config/secrets.yml` on a development environment for convenience, but in a production environment is necessary to define them on the OS when executing the server for obvious security reasons.

**Note:** The email receiver has to be whitelisted on Mailgun's web.

#### Authentication

In order to provide token-based authentication, I've used `bcrypt` to store hashed passwords on the database and `jwt` to generate authentication tokens based on server's secret key.  

Once the login credentials are checked (email and password), a token is generated using user's id and server's secret key.  

By adding this token on the header of each request a client can identify himself as a registered user.

#### Rate limit and throttling

By adding `rack-attack` gem, we can easily define rate limit parameters and whitelist certain clients.
Rate limit is defined to 20 requests every 5 seconds, and all local requests are whitelisted.  
If a request exceeds the rate limit, returns an error message to the client.  
