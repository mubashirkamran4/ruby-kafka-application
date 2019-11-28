
require "kafka"
require "avro_turf"
require "byebug"

class KafkaApp

    def self.kafka_client
      # initialize the kafka client in app once and then reuse it
      @kafka ||= Kafka.new(["0:9092", "1:9093"], client_id: "hobbies_application")
    end

    def self.avro_client
      @avro ||= AvroTurf.new(schemas_path: "./")
    end

    # 1ST STEP. CREATE A TOPIC WITH 3 PARTITIONS AND A REPLICATION FACTOR OF 2
    def create_topic(topic_name, num_of_partitions, replication_per_partition)
      puts "*********CREATING HOBBIES TOPIC WITH 3 PARTITIONS AND A REPLICATION FACTOR OF 2*****************\n\n"
      kafka_cl = KafkaApp.kafka_client
      kafka_cl.create_topic(topic_name, num_partitions: num_of_partitions, replication_factor: replication_per_partition)
    end

end

