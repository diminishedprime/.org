package linked_list;

import org.junit.Test;

import static linked_list.MyList.*;
import static org.junit.Assert.assertEquals;

/**
 * Created by mjhamrick on 12/20/16.
 */
public class _5Test {

    @Test
    public void test() {

        //  Input:(7-> 1 -> 6) + (5 -> 9 -> 2).Thatis,617 + 295. Output:2 -> 1 -> 9.Thatis,912.

        MyList<Integer> a =        listOf(7, 1, 6);
        MyList<Integer> b =        listOf(5, 9, 2);
        MyList<Integer> expected = listOf(2, 1, 9);
        MyList<Integer> sum = _5.sum(a, b);

        assertEquals(expected, sum);

    }

    @Test
    public void testABigger() {

        MyList<Integer> a =        listOf(7, 1, 6, 3);
        MyList<Integer> b =        listOf(5, 9, 2);
        MyList<Integer> expected = listOf(2, 1, 9, 3);
        MyList<Integer> sum = _5.sum(a, b);

        assertEquals(expected, sum);
    }

    public void testBBigger() {
        MyList<Integer> a =        listOf(7, 1, 6);
        MyList<Integer> b =        listOf(5, 9, 2, 3);
        MyList<Integer> expected = listOf(2, 1, 9, 3);
        MyList<Integer> sum = _5.sum(a, b);

        assertEquals(expected, sum);
    }

    @Test
    public void test4() {
        MyList<Integer> a =        listOf(7, 1, 9);
        MyList<Integer> b =        listOf(3);
        MyList<Integer> expected = listOf(0, 2, 9);
        MyList<Integer> sum = _5.sum(a, b);

        assertEquals(expected, sum);


    }

    @Test
    public void test3() {
        MyList<Integer> a =        listOf(7, 1, 4);
        MyList<Integer> b =        listOf(5, 9, 5);
        MyList<Integer> expected = listOf(2, 1, 0, 1);
        MyList<Integer> sum = _5.sum(a, b);

        assertEquals(expected, sum);
    }

}
