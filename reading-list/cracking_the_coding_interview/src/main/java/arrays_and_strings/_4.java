package arrays_and_strings;

import java.util.HashMap;
import java.util.Optional;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _4 {
    // Palindrome Permutation: Given a string, write a function to check if
    // it is a permutation of a palindrome. A palindrome is a word or phrase
    // that is the same forwards and backwards. A permutation is a
    // rearrangement of letters. The palindrome does not need to be limited
    // to just dictionary words.
    // EXAMPLE
    // Input: Tact Coa
    // Output: True (permutations: "taco cat", "atco cta", etc.)
    // Hints:#106,#121,#134,#136
    public static boolean palindromePermutation(String string) {
        HashMap<String, Integer> letterCounts = new HashMap<>(string.length());
        for (int i = 0; i < string.length(); i++) {
            String subs = string.substring(i, i + 1).toLowerCase();
            if (subs.equals(" ")) {
                continue;
            }
            Integer countOptional = letterCounts.get(subs);
            Integer count = (countOptional != null) ? countOptional : 0;
            letterCounts.put(subs, count + 1);
        }
        boolean oddCount = false;
        for (Integer value : letterCounts.values()) {
            if (value % 2 == 1) {
                if (oddCount) {
                    return false;
                } else {
                    oddCount = true;
                }
            }
        }
        return true;
    }
}
