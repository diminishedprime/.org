package stacks_and_queues;

import org.junit.Test;
import stacks_and_queues._3.SetOfStacks;

import static org.junit.Assert.assertEquals;


/**
 * Created by mjhamrick on 12/23/16.
 */
public class _3Test {

    @Test
    public void test() {

        SetOfStacks<Integer> val = new SetOfStacks<Integer>();

        for (int i = 0; i < 30; i++) {
            val.push(i);
        }

        for (int i = 29; i >= 0; i--) {
            assertEquals(Integer.valueOf(i), val.pop());
        }

        for (int i = 0; i < 30; i++) {
            val.push(i);
        }

        assertEquals(Integer.valueOf(5), val.popAt(1));
    }

}
