
require "kafka"
require "avro_turf"
require "byebug"

class KafkaApp

    def self.kafka_client
      # initialize the kafka client in app once and then reuse it
      @kafka ||= Kafka.new(["0:9092", "1:9093"], client_id: "hobbies_application")
    end

    def self.producer
      KafkaApp.kafka_client.producer
    end

    def self.consumer(group_id)
      KafkaApp.kafka_client.consumer(group_id: "#{group_id}_consumer_group")
    end

    def self.avro_client
      @avro ||= AvroTurf.new(schemas_path: "./")
    end

    # 1ST STEP. CREATE A TOPIC WITH 3 PARTITIONS AND A REPLICATION FACTOR OF 2
    def create_topic(topic_name, num_of_partitions, replication_per_partition)
      puts "*********CREATING HOBBIES TOPIC WITH 3 PARTITIONS AND REPLICATION FACTOR OF 2*****************\n\n"
      kafka_cl = KafkaApp.kafka_client
      kafka_cl.create_topic(topic_name, num_partitions: num_of_partitions, replication_factor: replication_per_partition)
    end

    # 2ND STEP. WRITE MESSAGE TO PRODUCER BUFFER USING AVRO SCHEMA
    def write_message(hobby_name, topic_name, partition_id, avro_schema_name)
      puts "WRITING MESSAGE <#{hobby_name}> TO TOPIC <#{topic_name}> IN PARTITION <#{partition_id}> ACCORDING TO SCHEMA <#{avro_schema_name}>"
      #INITIALLY IT WAS WRITTEN THIS WAY BEFORE AVRO SCHEMA
      #producer.produce(hobby_name, topic: topic_name, partition_key: partition_id)
      data = KafkaApp.avro_client.encode({ "title" => hobby_name }, schema_name: avro_schema_name)
      KafkaApp.producer.produce(data, topic: topic_name, partition_key: partition_id)
    end

    def deliver_all_messages
      KafkaApp.producer.deliver_messages
    end

    def subscribe_to_topic(topic, consume_from_flag)
      KafkaApp.consumer(topic).subscribe(topic, start_from_beginning: consume_from_flag)
    end

    def consume_messages(topic_name, avro_schema_name)
      KafkaApp.kafka_client.each_message(topic: topic_name) do |message|
        puts "MESSAGE OFFSET: #{message.offset}, MESSAGE KEY: #{message.key}, MESSAGE VALUE: #{message.value} , MESSAGE PARTITION: #{message.partition}"
        hobby = KafkaApp.avro_client.decode(message.value, schema_name: avro_schema_name)
        puts "ACCORDING TO AVRO SCHEMA IT IS \n"
        puts hobby.inspect
      end
    end



end


