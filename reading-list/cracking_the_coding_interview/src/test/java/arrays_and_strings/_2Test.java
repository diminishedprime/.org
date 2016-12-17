package arrays_and_strings;

import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _2Test {

    String bigAssString = "natexsnatxoentaxosentiaxrcexa,.crixra,.tbiatoeaisoetuxasrc,.xtiarc,duantoearxircabeliaxoercuxanoteuxaenobu";
    String shuffled = "natexsnatxoentaxosentiaxrcexa,.crixra,.tbiatoeaisoetuxasrc,.xtiarc,duantoearxircabeliaxoercuxanoteuxaenoub";

    @Test
    public void isPermutationWithFixedCharacterSet() {
        assertTrue(_2.isPermutationWithFixedCharset("abc", "cba"));
        assertFalse(_2.isPermutationWithFixedCharset("aa", "a"));
        assertTrue(_2.isPermutationWithFixedCharset("", ""));
        assertTrue(_2.isPermutationWithFixedCharset("cde", "cde"));
    }

    @Test
    public void isPermutationWithSorting() {
        assertTrue(_2.isPermutationWithSorting("abc", "cba"));
        assertFalse(_2.isPermutationWithSorting("aa", "a"));
        assertTrue(_2.isPermutationWithSorting("", ""));
        assertTrue(_2.isPermutationWithSorting("cde", "cde"));

        long start = System.nanoTime();
        assertTrue(_2.isPermutationWithSorting(bigAssString, shuffled));
        long stop = System.nanoTime();
        long diff = stop - start;
        System.out.println(diff);
    }

    @Test
    public void isPermutationWithoutSorting() {
        assertTrue(_2.isPermutationWithoutSorting("abc", "cba"));
        assertFalse(_2.isPermutationWithoutSorting("aa", "a"));
        assertTrue(_2.isPermutationWithoutSorting("", ""));
        assertTrue(_2.isPermutationWithoutSorting("cde", "cde"));

        long start = System.nanoTime();
        assertTrue(_2.isPermutationWithoutSorting(bigAssString, shuffled));
        long stop = System.nanoTime();
        long diff = stop - start;
        System.out.println(diff);
    }

}
