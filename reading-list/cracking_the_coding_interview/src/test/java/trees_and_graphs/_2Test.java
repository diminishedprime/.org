package trees_and_graphs;

import org.junit.Test;

import java.util.ArrayList;
import java.util.stream.IntStream;

import static java.util.stream.IntStream.*;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class _2Test {

    @Test
    public void test() {

        //System.out.println(_2.bstFromSortedArray(new Integer[]{1}));
        //System.out.println(_2.bstFromSortedArray(new Integer[]{1, 2, 3}));
        //System.out.println(_2.bstFromSortedArray(new Integer[]{1, 2, 3, 4}));
        //System.out.println(_2.bstFromSortedArray(new Integer[]{1, 2, 3, 4, 5, 6, 7}));

        int[] range = IntStream.range(1, 128).toArray();
        Integer[] ints = new Integer[range.length];
        for (int i = 0; i < range.length; i++) {
            ints[i] = range[i];
        }
        System.out.println(_2.bstFromSortedArray(ints));




    }

}
