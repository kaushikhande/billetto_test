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

### Design decisions and assumptions.

1. Event
   I have used billetto api for ingesting the events as assignment said. For this Assignment purpose, I have created the rake task for ingesting the 
   last 10 events.
   
   For real work, I would have used sidekiq for ingesting, Setup the scheduled task with fix interval for ingesting the new events added. In the 
   documentation, I 
   have also seen the Event webhooks for various changes in event such as created, published, using this we could setup webhooks in our application.

   billetto_id is considered to be unique, have created index for it in events table.
   Validated the presence of title, start and end date.

2. Clerk.com
   Used account portal so that we do not have to create sign in and sign up pages.
   After user is logged in first time, create user and update current_user as that user. This user table is needed at our end for vote tracibility. clerk_user_id will store the user_id from clerk.
   Also added email and name as column names. I have kept it minimal for this assignment purpose. I have not added unique index and unique validation
   for clerk_user_id but I should have kept it.

   To update the user data coming from clerk, we could create webhooks coming from clerk.com

3. Rails event store
   Created a vote model with user_id, enum for upvote and downvote and event_id column
   This will help us showing on frontend that user has upvoted the event or downvoted.
   Per event Per user create only 1 Vote, for next changes updated the same record.

   I have used rails event store as audit / history of vote by user for an event.
   After vote, I am publishing data: { event_id: event.id, user_id: user.id, vote_type: vote_type} to event stream Event$event_id.
   I have put this vote creation / updating and publishing in 1 transaction to gaurantee all or nothing. 

   For setting up I have refered the documentation for rails event store.
   1. gem "rails_event_store"
   2. Added migration 
   bin/rails generate ruby_event_store:active_record:migration
   bin/rails db:migrate
   3. Added Rails.configuration.event_store = event_store = RailsEventStore::Client.new in environment.rb in to prepare block.
