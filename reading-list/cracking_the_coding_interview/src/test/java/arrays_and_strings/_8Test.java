package arrays_and_strings;

import org.junit.Test;

import java.util.Arrays;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _8Test {

    @Test
    public void test() {

        int[][] matrix = new int[][] {
                {1,2,3},
                {0,2,3},
                {1,3,2},
                {8,0,1}
        };

        _8.zeroMatrix(matrix);

        for (int i = 0; i < matrix.length; i++) {
            System.out.println(Arrays.toString(matrix[i]));
        }

    }
}
