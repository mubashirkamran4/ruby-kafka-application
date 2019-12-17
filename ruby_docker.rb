require './kafka_producer.rb'
require './kafka_consumer.rb'
puts "HERE WE ARE"

kafka_producer = KafkaProducer.new
kafka_producer.create_topic("hobbies", 3 ,2)
kafka_producer.write_message("swimming", "hobbies" , "hobby")
kafka_producer.write_message("drawing", "hobbies", "hobby")
kafka_producer.write_message("sketching", "hobbies", "hobby")
kafka_producer.write_message("running", "hobbies", "hobby")
kafka_producer.write_message("body building", "hobbies", "hobby")
kafka_producer.write_message("jogging", "hobbies", "hobby")
kafka_producer.write_message("outing", "hobbies", "hobby")
kafka_producer.deliver_all_messages


kafka_consumer = KafkaConsumer.new
kafka_consumer.subscribe_to_topic("hobbies", true)
kafka_consumer.consume_messages("hobbies", "hobby")


