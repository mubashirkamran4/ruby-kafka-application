

class KafkaAppSpec

  # KAFKA CLIENT
  def kafka_client
    # initialize the kafka client in app once and then reuse it
    # Just initializing the hash as a mock for actual kafka client
    @kafka ||= {"borkers": ["PLAINTEXT://127.0.0.1:9093" , "PLAINTEXT://127.0.0.1:9094"], "client_id": "hobbies_application"}
  end

  # 1ST STEP. CREATE A TOPIC WITH 3 PARTITIONS AND A REPLICATION FACTOR OF 2
  def create_topic(topic, num_of_partitions, replication_per_partition)
    puts "*********CREATING HOBBIES TOPIC WITH 3 PARTITIONS AND A REPLICATION FACTOR OF 2*****************\n\n"
    kafka_cl = kafka_client
    @kafka_topic ||= {}
    if @kafka_topic.key?(topic)
      return topic
    else
      @kafka_topic[topic] = {}
      @kafka_topic[topic]["num_of_partitions"] = num_of_partitions
      @kafka_topic[topic]["replication_per_partition"] = replication_per_partition
      return topic
    end
  end

end

