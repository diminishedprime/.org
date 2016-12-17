package arrays_and_strings;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _8 {
    // Zero Matrix: Write an algorithm such that if an element in an
    // MxN matrix is 0, its entire row and column are set to 0.
    // Hints:#17, #74, #702

    public static void zeroMatrix(int[][] matrix) {
        Set<Integer> zeroedColumns = new HashSet<>();

        x:
        for (int i = 0; i< matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                if (matrix[i][j] == 0 && !zeroedColumns.contains(j)) {
                    zeroRow(matrix, i);
                    zeroColumn(matrix, j);
                    zeroedColumns.add(j);
                    continue x;
                }
            }
        }
    }

    private static void zeroRow(int[][] matrix, int i) {
        matrix[i] = new int[matrix[i].length];
    }

    private static void zeroColumn(int[][] matrix, int j) {
        for (int i = 0; i < matrix.length; i++) {
            matrix[i][j] = 0;
        }
    }


}
