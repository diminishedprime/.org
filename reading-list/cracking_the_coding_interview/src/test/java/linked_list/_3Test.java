package linked_list;

import org.junit.Test;

import static junit.framework.TestCase.assertEquals;

/**
 * Created by mjhamrick on 12/20/16.
 */
public class _3Test {

    @Test
    public void test() {

        Node<Character> list = new Node<Character>('a');
        for (int i = 'b'; i <= 'f'; i++) {
            list.appendToTail((char) i);
        }
        _3.delete_middle_node(list.next.next);

        Node<Character> expected = Node.of('a', 'b', 'd', 'e', 'f');
        assertEquals(expected, list);

    }

}
