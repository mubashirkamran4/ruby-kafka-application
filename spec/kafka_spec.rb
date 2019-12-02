require_relative './spec_helper.rb'
require_relative '../kafka_app_spec_class'
require_relative '../kafka_producer_spec_class'
require_relative '../kafka_consumer_spec_class'

describe 'kafka_application' do

  topic = "hobbies"
  avro_schema = "hobby"
  kafka_producer = KafkaProducerSpec.new
  kafka_consumer = KafkaConsumerSpec.new

  it "should be able to successfully create the topic" do
    kafka_client = KafkaAppSpec.new
    expect(kafka_client.create_topic(topic, 3, 2)).to eq(topic)
  end

  it "should be able to successfully write messages to topic" do
    expect(kafka_producer.write_message({ "title" => "swimming", "user" => "mubashir" }, topic, avro_schema)).to eq({ "title" => "swimming", "user" => "mubashir" })
    expect(kafka_producer.write_message({ "title" => "sketching", "user" => "mubashir" }, topic, avro_schema)).to eq({ "title" => "sketching", "user" => "mubashir" })

  end

  it "should be able to successfully deliver the messages from producer buffer" do
    expect(kafka_producer.deliver_all_messages("hobbies")).to eq(true)
  end

  it "should be able to successfully subscribe to topic before consuming it" do
    expect(kafka_consumer.subscribe_to_topic("hobbies", true)).to eq(true)
  end

  it "should be able to successfully consume messages from the topic" do
    expect(kafka_consumer.consume_messages(topic, avro_schema)).to eq(true)
  end



end
