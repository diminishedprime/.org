package ch05;

import kafka.producer.Partitioner;

/**
 * Created by kbvv on 1/31/17.
 */
public class SimplePartitioner implements Partitioner {

    @Override
    public int partition(Object key, int numPartitions) {
        int partition = 0;
        int iKey = (int) key;
        if (iKey > 0) {
            partition = iKey % numPartitions;
        }
        return partition;
    }
}
