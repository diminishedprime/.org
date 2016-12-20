package linked_list;

import org.junit.Test;

import static junit.framework.TestCase.assertEquals;

/**
 * Created by mjhamrick on 12/17/16.
 */
public class _1Test {

    @Test
    public void test() {

        Node<Integer> expected = new Node<Integer>(0);
        expected.appendToTail(1);
        expected.appendToTail(2);
        expected.appendToTail(3);

        Node<Integer> actual = new Node<Integer>(0);
        actual.appendToTail(1);
        actual.appendToTail(0);
        actual.appendToTail(2);
        actual.appendToTail(3);
        actual.appendToTail(3);
        _1.dedupe(actual);

        assertEquals(expected, actual);
    }
}
