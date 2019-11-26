
require "kafka"
require "avro_turf"

class KafkaApp

    def self.kafka_client
      # initialize the kafka client and app once and then reuse it
      @kafka ||= Kafka.new(["kafka1:9092", "kafka2:9092"], client_id: "hobbies_application")
    end

    def self.producer
      kafka_client.producer
    end

    def self.consumer
      kafka_client.consumer
    end

    def self.avro_client
      @avro ||= AvroTurf.new(schemas_path: "./")
    end

    def create_topic(topic_name, num_of_partitions, replication_per_partition)
      puts "*********CREATING HOBBIES TOPIC WITH 3 PARTITIONS AND REPLICATION FACTOR OF 2*****************\n\n"
      kafka_client.create_topic(topic_name, num_partitions: num_of_partitions, replication_factor: replication_per_partition)
      kafka_client
    end

    def write_message(hobby_name, topic_name, partition_id, avro_schema_name)
      puts "WRITING MESSAGE <#{hobby_name}> TO TOPIC <#{topic_name} IN PARTITION <#{partition_id}> ACCORDING TO SCHEMA <#{avro_schema}>"
      #INITIALLY IT WAS WRITTEN THIS WAY BEFORE AVRO SCHEMA
      #producer.produce(hobby_name, topic: topic_name, partition_key: partition_id)
      data = avro_client.encode({ "hobby" => hobby_name }, schema_name: avro_schema_name)
      producer.produce(data, topic: topic_name, partition_key: partition_id)
    end

    def deliver_all_messages
      producer.deliver_messages
    end

    def subscribe_to_topic(topic, consume_from_flag)
      consumer.subscribe(topic, start_from_beginning: consume_from_flag)
    end

    def consume_messages(topic_name, avro_schema_name)
      kafka_client.each_message(topic: topic_name) do |message|
        puts "MESSAGE OFFSET: #{message.offset}, MESSAGE KEY: #{message.key}, MESSAGE VALUE: #{message.value} , MESSAGE PARTITION: #{message.partition}"
        hobby = avro_client.decode(message.value, schema_name: avro_schema_name)
        puts "ACCORDING TO AVRO SCHEMA IT IS \n"
        puts hobby.inspect
      end
    end



end


