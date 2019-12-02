class KafkaProducerSpec < KafkaAppSpec

  def self.producer
    @kafka_producer ||= KafkaAppSpec.kafka_client
  end

  # 2ND STEP. WRITE MESSAGE TO PRODUCER BUFFER USING AVRO SCHEMA
  def write_message(user_hobby, topic, avro_schema)
    puts "WRITING MESSAGE #{user_hobby} TO TOPIC <#{topic}> ACCORDING TO SCHEMA <#{avro_schema}>"
    avro_schema_file = File.open("./#{avro_schema}.avsc")  # to make sure it exists
    @@kafka_topic[topic].key?("buffered_messages") || @@kafka_topic[topic]["buffered_messages"] = []
    @@kafka_topic[topic]["buffered_messages"].append(user_hobby)
    written_message = @@kafka_topic[topic]["buffered_messages"][-1] # RETURN THE LAST WRITTEN MESSAGE TO CALLING CASE
    puts "SUCCESSFULLY WROTE THE MESSAGE #{written_message.inspect} TO TOPIC <#{topic}> ACCORDING TO SCHEMA <#{avro_schema}>"
    return written_message
  end

  # 3RD STEP. DELIVER ALL MESSAGES PRESENT IN THE BUFFER
  def deliver_all_messages(topic)
    puts "GOING TO DELIVER THE MESSAGES FROM BUFFER"
    @@kafka_topic[topic].key?("delivered_messages") ||  @@kafka_topic[topic]["delivered_messages"] = []
    buffered_messages = @@kafka_topic[topic]["buffered_messages"].dup
    @@kafka_topic[topic]["delivered_messages"].append(buffered_messages)
    @@kafka_topic[topic]["delivered_messages"] = @@kafka_topic[topic]["delivered_messages"].flatten
    @@kafka_topic[topic]["buffered_messages"] = [] # emptying buffered messages as we have transferred them to delivered messages array
    puts "MESSAGES DELIVERED"
    return true # reaching here means all messages are delivered so returning true to the calling case
  end


end