class KafkaConsumerSpec < KafkaAppSpec

  @consumed_messages = []

  def self.consumer
    @kafka_consumer ||= kafka_client
  end

  # 4TH STEP. SUBSCRIBE TO TOPIC BEFORE CONSUMING MESSAGES
  def subscribe_to_topic(topic, consume_from_flag)
    puts "GOING TO SUBSCRIBE TO TOPIC\n\n"
    @kafka_topic.key?(topic)
  end

  # 5TH STEP. CONSUME MESSAGES FROM THE BUFFER
  def consume_messages(topic, avro_schema)
    puts "GOING TO CONSUME DELIVERED MESSAGES"
    avro_schema = File.open("./#{avro_schema}.avsc")  # to make sure it exists
    @kafka_topic[topic]["delivered_messages"].each do |message|
      puts "Message: #{message.inspect}\n"
    end
    @consumed_messages.append(@kafka_topic[topic]["delivered_messages"])
    @consumed_messages = @consumed_messages.flatten
    @kafka_topic[topic]["delivered_messages"] = [] # means delivered messages are now consumed by consumer
    puts "ALL MESSAGES CONSUMED"
    return true # reaching here means we have consumed all messages in buffer successfully
  end

end