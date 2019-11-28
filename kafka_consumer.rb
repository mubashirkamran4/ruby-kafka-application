
class KafkaConsumer < KafkaApp

  def self.consumer(group_id)
    @kafka_consumer ||= KafkaApp.kafka_client.consumer(group_id: "#{group_id}_consumer_group")
  end

  def subscribe_to_topic(topic, consume_from_flag)
    KafkaConsumer.consumer(topic).subscribe(topic, start_from_beginning: consume_from_flag)
  end

  def consume_messages(topic, avro_schema_name)
    KafkaConsumer.consumer(topic).each_message do |message|
      puts "MESSAGE OFFSET: #{message.offset}, MESSAGE PARTITION: #{message.partition}"
      p message.value
      hobby = KafkaApp.avro_client.decode(message.value, schema_name: avro_schema_name)
      if hobby['user'] == 'mubashir'
        p "hey i'm mubashir"
      end
      puts "ACCORDING TO AVRO SCHEMA IT IS \n"
      puts hobby.inspect
    end
  end

end