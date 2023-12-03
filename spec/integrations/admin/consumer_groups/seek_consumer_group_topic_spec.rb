# frozen_string_literal: true

# We should be able to move the offset on a topic level and it should move where expected

setup_karafka

class Consumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
      DT[0] << message.offset
    end
  end
end

draw_routes(Consumer)

elements = DT.uuids(10)
produce_many(DT.topic, elements)

start_karafka_and_wait_until do
  DT[0].size >= 10
end

used_client_id = Karafka::App.config.client_id

# Reinitialize so we get new producer we can use
setup_karafka do |config|
  config.client_id = used_client_id
  config.producer = nil
end

# Produce one more so we can get the new offset for checking
produce_many(DT.topic, DT.uuids(1))

assert_equal 10, fetch_first_offset

Karafka::Admin.seek_consumer_group(
  DT.consumer_group,
  { DT.topic => 5 }
)

assert_equal 5, fetch_first_offset
