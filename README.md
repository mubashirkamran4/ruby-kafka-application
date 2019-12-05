# ruby-kafka-application
First and basic kafka application in ruby

PRELIMINARY STEPS

1). Open the terminal and clone the project using "git@github.com:mubashirkamran4/ruby-kafka-application.git". We need to have the ssh key setup on our github account for this purpose.

2). First of all, we just need to download the kafka v 2.3.0 scripts required to start the kafka instances from https://www.apache.org/dyn/closer.cgi?path=/kafka/2.3.0/kafka_2.12-2.3.0.tgz

3). Place the directory inside the project folder. Navigate to the project directory using cd command on terminal and run:
>tar -xzf kafka_2.12-2.3.0.tgz


4). Now, first of all we need to start the zoopkeeper required to run kafka broker instances via following command:
> kafka_2.12-2.3.0/bin/zookeeper-server-start.sh kafka_2.12-2.3.0/config/zookeeper.properties

5). Copy the files present in the project's main folder "server-1.properties" and "server-2.properties" to "kafka_2.12-2.3.0/config" directory
and open two terminals separately to run the kafka seeds on them.

6). Run the following commands on both of newly opened terminals to start the seeds:

> kafka_2.12-2.3.0/bin/kafka-server-start.sh kafka_2.12-2.3.0/config/server-1.properties

> kafka_2.12-2.3.0/bin/kafka-server-start.sh kafka_2.12-2.3.0/config/server-2.properties

HOW TO RUN THE PROJECT

1). Open a new terminal, navigate to the project directory and run "bundle install" to install all the required gems.

2). Now, run the following commands on the same terminal:

>  require './kafka_producer.rb'

>  kafka_producer = KafkaProducer.new

>  kafka_producer.create_topic("hobbies", 3 ,2)

>  kafka_producer.write_message("swimming", "hobbies" , "hobby")

>  kafka_producer.write_message("drawing", "hobbies", "hobby")

3). Uptil now, the messages written using write_message of producer object will stay in buffer. For consuming them just right after
they are delivered to actual topic, we need to start the kafka consumer and have it subscribed to topic. for this purpose,
open a new terminal and run the following commands:

> require './kafka_consumer.rb'

> kafka_consumer = KafkaConsumer.new

> kafka_consumer.subscribe_to_topic("hobbies", true)

> kafka_consumer.consume_messages("hobbies", "hobby")

The consumer would be waiting for the messages to consume at this point.

4). Now, go to the producer's terminal and run:

> kafka_producer.deliver_all_messages

We should see the messages printed in the consumer's terminal by now.


HOW TO RUN THE TEST CASES

1). Run the command "rspec spec/kafka_spec.rb" to run the test cases in the project's directory.
