require './kafka_app.rb'

class KafkaProducer < KafkaApp

  def producer
    @kafka_producer ||= kafka_client.producer
  end

  # 2ND STEP. WRITE MESSAGE TO PRODUCER BUFFER USING AVRO SCHEMA
  def write_message(hobby_name, topic_name, avro_schema_name)
    puts "WRITING MESSAGE <#{hobby_name}> TO TOPIC <#{topic_name}> ACCORDING TO SCHEMA <#{avro_schema_name}>"
    #INITIALLY IT WAS WRITTEN THIS WAY BEFORE AVRO SCHEMA
    #producer.produce(hobby_name, topic: topic_name, partition_key: partition_id)
    data = avro_client.encode({ "title" => hobby_name, "user" => 'mubashir' }, schema_name: avro_schema_name)
    producer.produce(data, topic: topic_name)
    puts "Ended Here"
  end

  def deliver_all_messages
    puts "GOING TO DELIVER ALL THE MESSAGES"
    producer.deliver_messages
  end


end