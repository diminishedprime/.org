package ch05;

import java.util.Properties;
import kafka.javaapi.producer.Producer;
import kafka.producer.KeyedMessage;
import kafka.producer.ProducerConfig;


/**
 * Created by kbvv on 1/31/17.
 */
public class SimpleProducer {

    // This doesn't work for some reason...
    // mvn org.codehaus.mojo:exec-maven-plugin:1.5.0:java -Dexec.mainClass="ch05.SimpleProducer" -Dexec.args="kafka-topic, Hello_There"

    private static Producer<Integer, String> producer;
    private final Properties props = new Properties();

    public SimpleProducer() {
        props.put("broker.list", "localhost:9092");
        props.put("serializer.class", "kafka.serializer.StringEncoder");
        props.put("request.required.acks", "1");
        producer = new Producer<Integer, String>(new ProducerConfig(props));
    }

    public static void main(String[] args) {
        SimpleProducer sp = new SimpleProducer();
        String topic = (String) args[0];
        String message = (String) args[1];
        KeyedMessage<Integer, String> data = new KeyedMessage<Integer, String>(topic, message);
        producer.send(data);
        producer.close();
    }

}
