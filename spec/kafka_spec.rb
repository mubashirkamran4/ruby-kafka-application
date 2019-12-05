require_relative './spec_helper.rb'
require_relative '../kafka_app'
require_relative '../kafka_producer'
require_relative '../kafka_consumer'

describe 'kafka_application' do


    # @kafka_client = KafkaApp.new
    # @kafka_producer = KafkaProducer.new
    # @kafka_consumer = KafkaConsumer.new
    # @topic =  "hobbies"
    # @avro_schema = "hobby"

    let(:fake_kafka_client) { double("Kafka") }
    let(:kafka_producer) { KafkaProducer.new }
    let(:kafka_consumer) { KafkaConsumer.new }
    let(:topic) { "hobbies" }
    let(:avro_schema) { "hobby" }
    let(:num_of_partitions) { 3 }
    let(:replication_per_partition) { 2 }
    let(:fake_avro_client) { double("Avro") }
    let(:fake_kafka_producer) { double("KafkaProducer") }
    let(:fake_kafka_consumer) { double("KafkaConsumer") }

    let(:hobby_name) { "swimming" }


    context "testing the producer's write and delivering functionalities" do
    before do
      allow_any_instance_of(KafkaApp).to receive(:kafka_client).and_return(fake_kafka_client)
      allow_any_instance_of(KafkaProducer).to receive(:avro_client).and_return(fake_avro_client)
      allow_any_instance_of(KafkaProducer).to receive(:producer).and_return(fake_kafka_producer)
      allow(fake_avro_client).to receive(:encode).with({"title" => hobby_name, "user" => "mubashir"}, schema_name: avro_schema)
    end

    it "client should be able to successfully create the topic" do

      expect(fake_kafka_client).to receive(:create_topic).with(topic, num_partitions: num_of_partitions, replication_factor: replication_per_partition)
      KafkaApp.new.create_topic(topic, num_of_partitions, replication_per_partition)
    end

    it "should be able to successfully write and deliver messages to topic" do
      expect(fake_kafka_producer).to receive(:produce).with(anything, topic: topic)
      expect(fake_kafka_producer).to receive(:deliver_messages)

      kafka_producer.write_message(hobby_name, topic, avro_schema)
      kafka_producer.deliver_all_messages
    end
  end


  context "testing the consumer's subscribe functionality" do
    before do
      allow_any_instance_of(KafkaConsumer).to receive(:consumer).with(topic).and_return(fake_kafka_consumer)


    end

    it "should be able to successfully subscribe to topic and then consuming messages from topic" do
      expect(fake_kafka_consumer).to receive(:subscribe).with(topic, start_from_beginning: true)
      allow(fake_kafka_consumer).to receive(:each_message)

      kafka_consumer.subscribe_to_topic(topic, true)
      kafka_consumer.consume_messages(topic, avro_schema)
    end
  end


end
