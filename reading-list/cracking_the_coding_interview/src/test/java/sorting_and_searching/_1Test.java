package sorting_and_searching;

import org.junit.Test;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;

/**
 * Created by mjhamrick on 12/29/16.
 */
public class _1Test {

    @Test
    public void mergeSortedTest() {

        Integer[] a = new Integer[] {1, 2, 3, null, null};
        Integer[] b = new Integer[] {2, 5};
        Integer[] expected = new Integer[] {1, 2, 2, 3, 5};

        _1.mergeSorted(a, b);
        assertThat(a, is(expected));

    }



}
