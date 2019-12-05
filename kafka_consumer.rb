require './kafka_app.rb'


class KafkaConsumer < KafkaApp

  def consumer(group_id)
    @kafka_consumer ||= kafka_client.consumer(group_id: "#{group_id}_consumer_group")
  end

  def subscribe_to_topic(topic, consume_from_flag)
    consumer(topic).subscribe(topic, start_from_beginning: consume_from_flag)
  end

  def consume_messages(topic, avro_schema_name)
    consumer(topic).each_message do |message|
      puts "MESSAGE OFFSET: #{message.offset}, MESSAGE PARTITION: #{message.partition}"
      p message.value
      hobby = avro_client.decode(message.value, schema_name: avro_schema_name)
      puts "ACCORDING TO AVRO SCHEMA IT IS \n"
      puts hobby.inspect
      puts "**\n"
    end
  end

end