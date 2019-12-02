

class KafkaAppSpec

  self.kafka_topic = {}
  def self.kafka_client
    # initialize the kafka client in app once and then reuse it
    # @kafka ||= Kafka.new(["0:9092", "1:9093"], client_id: "hobbies_application")
    @kafka ||= {"borkers": ["0:9092" , "1:9093"], "client_id": "hobbies_application"}
  end

  def self.avro_client
    @avro ||= "./" # schema should be present here.
  end

  # 1ST STEP. CREATE A TOPIC WITH 3 PARTITIONS AND A REPLICATION FACTOR OF 2
  def create_topic(topic_name, num_of_partitions, replication_per_partition)
    puts "*********CREATING HOBBIES TOPIC WITH 3 PARTITIONS AND A REPLICATION FACTOR OF 2*****************\n\n"
    kafka_cl = KafkaAppSpec.kafka_client
    if KafkaAppSpec.kafka_topic.key?(topic_name)
      return topic_name
    else
      KafkaAppSpec.kafka_topic[topic_name] = [{}]
      KafkaAppSpec.kafka_topic[topic_name][num_of_partitions] = num_of_partitions
      KafkaAppSpec.kafka_topic[topic_name][replication_per_partition] = replication_per_partition
      KafkaAppSpec.kafka_topic[topic_name][messages] = []
        return topic_name
    end
  end

end

