
require "kafka"
require "avro_turf"


class KafkaApp

    def kafka_client
      # initialize the kafka client in app once and then reuse it
      @kafka ||= Kafka.new(["PLAINTEXT://kafka1:9093"], client_id: "hobbies_application")
    end

    def avro_client
      @avro ||= AvroTurf.new(schemas_path: "./")
    end

    # 1ST STEP. CREATE A TOPIC WITH 3 PARTITIONS AND A REPLICATION FACTOR OF 2
    def create_topic(topic_name, num_of_partitions, replication_per_partition)
      puts 'foo'
      puts "*********CREATING HOBBIES TOPIC WITH 3 PARTITIONS AND A REPLICATION FACTOR OF 2*****************\n\n"
      kafka_client.create_topic(topic_name, num_partitions: num_of_partitions) # returns true if succeeded
    end

end

