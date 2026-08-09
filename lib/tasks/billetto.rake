namespace :billetto do
  desc "Ingest public events from Billetto"

  task ingest_events: :environment do
    Billetto::Events.sync

    puts "Billetto events ingested successfully"
  end
end
