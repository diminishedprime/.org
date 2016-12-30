package sorting_and_searching;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by mjhamrick on 12/29/16.
 */
public class _4Test {

    @Test
    public void test() {

        _4.NoSizeList mySpecialList = new _4.NoSizeList();
        for (int i = 7; i < 30; i++) {
            mySpecialList.add(i);
        }
        int actual1 = _4.indexOf(mySpecialList, 12);
        int actual2 = _4.indexOf(mySpecialList, 29);
        int actual3 = _4.indexOf(mySpecialList, 3);

        assertEquals(5, actual1);
        assertEquals(22, actual2);
        assertEquals(-1, actual3);

    }
}
