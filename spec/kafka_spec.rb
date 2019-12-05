require_relative './spec_helper.rb'
require_relative '../kafka_app'
# require_relative '../kafka_producer'
# require_relative '../kafka_consumer'

describe 'kafka_application' do

  before(:each) do
    @kafka_client = KafkaApp.new
    # @kafka_producer = KafkaProducer.new
    # @kafka_consumer = KafkaConsumerSpec.new
    @topic =  "hobbies"
    @avro_schema = "hobby"
  end

  it "should be able to successfully create the topic" do
    allow_any_instance_of(KafkaApp).to receive(:create_topic).with(@topic, 3, 2).and_return(@topic)
    expect(@kafka_client.create_topic(@topic, 3, 2)).to eq(@topic)
  end

  context "testing the producer's write functionality" do
    before do
      @kafka_producer.create_topic(@topic, 3, 2)
    end

    it "should be able to successfully write messages to topic" do
      allow_any_instance_of(KafkaProducer).to receive(:write_message).with(anything, 3, 2).and_return(@topic)
      expect(@kafka_producer.write_message({ "title" => "swimming", "user" => "mubashir" }, @topic, @avro_schema)).to eq({ "title" => "swimming", "user" => "mubashir" })
      expect(@kafka_producer.write_message({ "title" => "sketching", "user" => "mubashir" }, @topic, @avro_schema)).to eq({ "title" => "sketching", "user" => "mubashir" })
    end
  end

  context "testing the producer's delivering and consumer's subscribe functionality" do
    before do
      @kafka_producer.create_topic(@topic , 3, 2)
      @kafka_producer.write_message({ "title" => "swimming", "user" => "mubashir" }, @topic, @avro_schema)
      @kafka_producer.write_message({ "title" => "sketching", "user" => "mubashir" }, @topic, @avro_schema)
    end

    it "should be able to successfully deliver the messages from producer buffer" do
      expect(@kafka_producer.deliver_all_messages(@topic)).to eq(true)
    end

  end

    context "testing the consumer's subscribe functionality" do
      before do
        @kafka_producer.create_topic(@topic , 3, 2)
        @kafka_producer.write_message({ "title" => "swimming", "user" => "mubashir" }, @topic, @avro_schema)
        @kafka_producer.write_message({ "title" => "sketching", "user" => "mubashir" }, @topic, @avro_schema)
        @kafka_producer.deliver_all_messages(@topic)
      end

      it "should be able to successfully subscribe to topic before consuming it" do
        expect(@kafka_consumer.subscribe_to_topic(@topic, true)).to eq(true)
      end
    end

      context "testing the consumer's consume messages functionality" do
        before do
          @kafka_producer.create_topic(@topic , 3, 2)
          @kafka_producer.write_message({ "title" => "swimming", "user" => "mubashir" }, @topic, @avro_schema)
          @kafka_producer.write_message({ "title" => "sketching", "user" => "mubashir" }, @topic, @avro_schema)
          @kafka_producer.deliver_all_messages(@topic)
          @kafka_consumer.subscribe_to_topic(@topic, true)
        end
        it "should be able to successfully consume messages from the topic" do
          expect(@kafka_consumer.consume_messages(@topic, @avro_schema)).to eq(true)
        end
      end


end
