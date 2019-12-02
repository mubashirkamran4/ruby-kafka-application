class KafkaProducerSpec < KafkaAppSpec

  def self.producer
    @kafka_producer ||= KafkaAppSpec.kafka_client
  end

  # 2ND STEP. WRITE MESSAGE TO PRODUCER BUFFER USING AVRO SCHEMA
  def write_message(user_hobby, topic, avro_schema)
    puts "WRITING MESSAGE #{user_hobby} TO TOPIC <#{topic}> ACCORDING TO SCHEMA <#{avro_schema}>"
    avro_schema_file = File.open("./#{avro_schema}.avsc")  # to make sure it exists
    KafkaAppSpec.kafka_topic.key?("buffered_messages") || KafkaAppSpec.kafka_topic["buffered_messages"] = []
    KafkaAppSpec.kafka_topic["buffered_messages"].append(user_hobby)
    return KafkaAppSpec.kafka_topic["buffered_messages"][-1]
  end

  def deliver_all_messages(topic)
    KafkaAppSpec.kafka_topic.key?("delivered_messages") ||  KafkaAppSpec.kafka_topic["delivered_messages"] = []
    buffered_messages = KafkaAppSpec.kafka_topic[topic]["buffered_messages"].dup
    KafkaAppSpec.kafka_topic[topic]["delivered_messages"].append(buffered_messages)
    KafkaAppSpec.kafka_topic[topic]["buffered_messages"] = []
    return true
  end


end