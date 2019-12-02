
class KafkaConsumerSpec < KafkaAppSpec

  self.consumed_messages = []
  def self.consumer
    @kafka_consumer ||= KafkaAppSpec.kafka_client
  end

  def subscribe_to_topic(topic, consume_from_flag)
    KafkaAppSpec.kafka_topic.key?(topic_name)
  end

  def consume_messages(topic, avro_schema)
    avro_schema = File.open("./#{avro_schema}.avsc")  # to make sure it exists
    delivered_messages = KafkaAppSpec.kafka_topic[topic]["delivered_messages"].dup
    delivered_messages.each do |message|
      puts "Message: #{message.inspect}\n"
    end
    KafkaAppSpec.kafka_topic[topic]["delivered_messages"] = []
  end

end