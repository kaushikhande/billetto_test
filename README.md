# Test Integrations

## Setup

Follow the steps below to set up the application locally.

### 1. Clone the Repository

Clone the `main` branch:

```bash
git clone <repository-url>
cd test_integrations
```

### 2. Configure Rails Master Key

The Rails `master.key` has been provided separately via email.

Copy the key from the email and save it to:

```text
config/master.key
```

The key is required to decrypt the Rails application credentials.

### 3. Configure Environment Variables

Copy the sample environment file:

```bash
cp .env.sample .env
```

Update `.env` with the required configuration values.

### 4. Install Ruby

Install **Ruby 4.0.6**.

Verify the installed version:

```bash
ruby -v
```

Expected version:

```text
ruby 4.0.6
```

### 5. Create MySQL Databases

Create the following MySQL databases according to the configuration in `.env`:

```text
test_integrations_development
test_integrations_test
```

### 6. Install Dependencies

Install the required Ruby gems:

```bash
bundle install
```

### 7. Run Database Migrations

Run the Rails database migrations:

```bash
bin/rails db:migrate
```

### 8. Ingest Events

To fetch and ingest events from Billetto, run:

```bash
bin/rails billetto:ingest_events
```

This populates the application's events data.

### 9. Run the Test Suite

Run all RSpec tests:

```bash
bundle exec rspec
```

All tests should pass before starting the application.

### 10. Start the Rails Server

Start the Rails development server:

```bash
bin/rails server
```

The application will be available at:

```text
http://localhost:3000
```
