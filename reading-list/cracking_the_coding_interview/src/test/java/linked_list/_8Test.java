package linked_list;

import org.junit.Test;

import static linked_list.MyList.*;
import static linked_list._8.beginningOfLoop;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class _8Test {

    @Test
    public void test() {

        MyList<Character> e = of('e', null);
        MyList<Character> c = of('c', of('d', e));
        e.setNext(c);
        MyList<Character> list = of('a', of('b', c));
        MyList<Character> actual = beginningOfLoop(list);
        assertTrue(actual == c);
    }

}
