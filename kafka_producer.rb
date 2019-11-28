class KafkaProducer < KafkaApp

  def self.producer
    @kafka_producer ||= KafkaApp.kafka_client.producer
  end

  # 2ND STEP. WRITE MESSAGE TO PRODUCER BUFFER USING AVRO SCHEMA
  def write_message(hobby_name, topic_name, partition_id, avro_schema_name)
    puts "WRITING MESSAGE <#{hobby_name}> TO TOPIC <#{topic_name}> IN PARTITION <#{partition_id}> ACCORDING TO SCHEMA <#{avro_schema_name}>"
    #INITIALLY IT WAS WRITTEN THIS WAY BEFORE AVRO SCHEMA
    #producer.produce(hobby_name, topic: topic_name, partition_key: partition_id)
    data = KafkaApp.avro_client.encode({ "title" => hobby_name }, schema_name: avro_schema_name)
    KafkaProducer.producer.produce(data, topic: topic_name, partition_key: partition_id)
    puts "Ended Here"
  end

  def deliver_all_messages
    KafkaProducer.producer.deliver_messages
  end


end