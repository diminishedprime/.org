package linked_list;

import org.junit.Test;

import static junit.framework.TestCase.assertEquals;

/**
 * Created by mjhamrick on 12/20/16.
 */
public class _2Test {

    @Test
    public void test2() {
        Node<Integer> list = new Node<>(0);
        for (int i = 1; i < 10; i++){
            list.appendToTail(i);
        }
        Integer actual = _2.kth_to_last_iter(list, 9);
        Integer expected = 1;
        assertEquals(expected, actual);
    }

    @Test
    public void test() {

        Node<Integer> list = new Node<Integer>(0);
        for (int i = 1; i < 10; i++) {
            list.appendToTail(i);
        }
        Integer actual = _2.kth_to_last(list, 4);
        Integer expected = 6;

        assertEquals(expected, actual);

    }
}
