package arrays_and_strings;

import org.junit.Test;

import java.util.Arrays;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _7Test {
    @Test
    public void test() {

        byte[][] image = new byte[][] {
                {0, 1, 2, 3},
                {4, 5, 6, 7},
                {8, 9, 10, 11},
                {12, 13, 14, 15}
        };
        _7.rotate90(image);

        for (int i = 0; i < image.length; i++) {
            System.out.println(Arrays.toString(image[i]));
        }

    }
}
