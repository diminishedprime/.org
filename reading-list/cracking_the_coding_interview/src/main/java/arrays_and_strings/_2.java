package arrays_and_strings;

import java.util.Arrays;
import java.util.Optional;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _2 {
    // Check Permutation: Given two strings,write a method to decide if one is a permutation of the other.
    // Hints: #7, #84, #722, #737

    public static boolean isPermutationWithSorting(String a, String b) {
        String newA = sortString(a);
        String newB = sortString(b);
        return newA.equals(newB);
    }

    private static String sortString(String check) {
        char[] asArray = check.toCharArray();
        Arrays.sort(asArray);
        return String.valueOf(asArray);
    }

    public static boolean isPermutationWithoutSorting(String a, String b) {
        if (a.length() != b.length()) {
            return false;
        }

        HashTable<String, Integer> aTable = new HashTable<>(a.length());
        HashTable<String, Integer> bTable = new HashTable<>(b.length());
        for (int i = 0; i < a.length(); i++) {
            String subs = a.substring(i, i + 1);
            Optional<Integer> currentValueOptional = aTable.get(subs);
            Integer currentValue = (currentValueOptional.isPresent()) ? currentValueOptional.get() : 0;
            aTable.put(subs, currentValue + 1);
        }
        for (int i = 0; i < b.length(); i++) {
            String subs = b.substring(i, i + 1);
            Optional<Integer> currentValueOptional = bTable.get(subs);
            Integer currentValue = (currentValueOptional.isPresent()) ? currentValueOptional.get() : 0;
            bTable.put(subs, currentValue + 1);
        }
        for (int i = 0; i < a.length(); i++) {
            String subs = a.substring(i, i + 1);
            Optional<Integer> fromA = aTable.get(subs);
            Optional<Integer> fromB = bTable.get(subs);
            if (fromB.isPresent() && fromA.get().equals(fromB.get())) {
                continue;
            } else {
                return false;
            }
        }
        return true;
    }
}
