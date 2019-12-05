require_relative './spec_helper.rb'
require_relative '../kafka_app'
require_relative '../kafka_producer'
require_relative '../kafka_consumer'

describe 'kafka_application' do

  before(:each) do
    @kafka_client = KafkaApp.new
    @kafka_producer = KafkaProducer.new
    @kafka_consumer = KafkaConsumer.new
    @topic =  "hobbies"
    @avro_schema = "hobby"
  end

  context "testing the producer's write and delivering functionalities" do
    before do
      allow_any_instance_of(KafkaApp).to receive(:create_topic).with(@topic, 3, 2).and_return(true)
      allow_any_instance_of(KafkaProducer).to receive(:write_message).with({"title" => anything, "user" => anything}, @topic, @avro_schema)
      allow_any_instance_of(KafkaProducer).to receive(:deliver_all_messages)
    end

    it "client should be able to successfully create the topic" do
      expect(@kafka_client.create_topic(@topic, 3, 2)).to eq(true)
    end

    it "should be able to successfully write and deliver messages to topic" do
      expect(@kafka_producer.write_message({ "title" => "swimming", "user" => "mubashir" }, @topic, @avro_schema)).to be_nil
      expect(@kafka_producer.write_message({ "title" => "sketching", "user" => "mubashir" }, @topic, @avro_schema)).to be_nil
      expect(@kafka_producer.deliver_all_messages).to be_nil
    end
  end


  context "testing the consumer's subscribe functionality" do
    before do
      allow_any_instance_of(KafkaConsumer).to receive(:subscribe_to_topic).with(@topic, true)
      allow_any_instance_of(KafkaConsumer).to receive(:consume_messages).with(@topic, @avro_schema)
    end

    it "should be able to successfully subscribe to topic and then consuming messages from topic" do
      expect(@kafka_consumer.subscribe_to_topic(@topic, true)).to be_nil
      expect(@kafka_consumer.consume_messages(@topic, @avro_schema)).to be_nil
    end
  end


end
