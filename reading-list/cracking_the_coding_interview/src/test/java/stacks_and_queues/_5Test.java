package stacks_and_queues;

import org.junit.Test;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class _5Test {

    @Test
    public void test() {

        MyStack<Integer> unsorted = new MyStack<>();
        unsorted.push(1);
        unsorted.push(13);
        unsorted.push(4);
        unsorted.push(4);
        unsorted.push(4);
        unsorted.push(4);
        unsorted.push(3);
        unsorted.push(-14);
        unsorted.push(8);
        MyStack<Integer> actual = _5.sortStack(unsorted);
        System.out.println(actual);

    }
}
