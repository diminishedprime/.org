package ch05;

import java.util.Properties;
import java.util.Random;
import kafka.javaapi.producer.Producer;
import kafka.producer.KeyedMessage;
import kafka.producer.ProducerConfig;

/**
 * Created by kbvv on 1/31/17.
 */
public class MultiBrokerProducer {

    // bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic kafkatopic --partitions 5 --replication-factor 2

    // mvn org.codehaus.mojo:exec-maven-plugin:1.5.0:java -Dexec.mainClass="ch05.MultiBrokerProducer" -Dexec.args="kafkatopic"

    // bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatopic --from-beginning

    private static Producer<Integer, String> producer;
    private final Properties props = new Properties();

    public MultiBrokerProducer() {
        props.put("metadata.broker.list", "localhost:9092, localhost:9093");
        props.put("serializer.class", "kafka.serializer.StringEncoder");
        props.put("partitioner.class", "ch05.SimplePartitioner");
        props.put("request.required.acks", "1");

        ProducerConfig config = new ProducerConfig(props);
        producer = new Producer<Integer, String>(config);
    }

    public static void main(String[] args) {
        MultiBrokerProducer sp = new MultiBrokerProducer();
        Random random = new Random();

        String topic = (String) args[0];
        for (long messageCount = 0; messageCount < 10; messageCount++) {
            Integer key = random.nextInt(255);
            String message = "This message is for key - " + key;
            KeyedMessage<Integer, String> data1 = new KeyedMessage<Integer, String>(topic, key, message);
            producer.send(data1);
        }
        producer.close();
    }
}
