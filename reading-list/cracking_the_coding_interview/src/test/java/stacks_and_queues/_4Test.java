package stacks_and_queues;

import org.junit.Test;

import java.util.IntSummaryStatistics;

import static org.junit.Assert.assertEquals;
import static stacks_and_queues._4.*;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class _4Test {

    @Test
    public void test() {

        MyQueue4 queue = new _4.MyQueue4<Integer>();
        for (int i = 0; i < 10; i++) {
            queue.add(i);
            queue.peek();
            queue.peek();
        }
        for (int i = 0; i < 10; i++) {
            queue.peek();
            assertEquals(i, queue.remove());
        }

    }
}
