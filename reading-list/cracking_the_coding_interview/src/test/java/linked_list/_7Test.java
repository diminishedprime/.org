package linked_list;

import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class _7Test {

    @Test
    public void test() {

        MyList<Integer> bPrime = MyList.listOf(1, 2, 3);
        MyList<Integer> a = MyList.of(15, MyList.of(14, bPrime));
        MyList<Integer> b = MyList.of(13, bPrime);

        assertEquals(bPrime, _7.intersect(a, b));
        assertEquals(bPrime, _7.intersect(b, a));
        assertNotEquals(bPrime, _7.intersect(a, MyList.listOf(1,2,3,4)));

    }

}
