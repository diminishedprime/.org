package arrays_and_strings;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by mjhamrick on 12/14/16.
 */
public class _1 {
    // Is Unique: Implement an algorithm to determine if a string has all unique characters.
    // What if you cannot use additional data structures? Hints: #44, #7 7 7, #732

    // Using a booleanArray assuming a fixed number of characters
    static boolean allUniqueCharactersWithFixedChar(String check) {
        if (check.length() > 128) {
            return false;
        }
        // assuming only ascii counts
        boolean[] seenYet = new boolean[128];

        for (int i = 0; i < check.length(); i++) {
            char currentChar = check.charAt(i);
            if (seenYet[currentChar]) {
                return false;
            } else {
                seenYet[currentChar] = true;
            }
        }
        return true;
    }

    // Using a bitArray
    static boolean allUniqueCharactersWithBitArray(String check) {
        int checker = 0;
        for (int i = 0; i < check.length(); i++) {
            int val = check.charAt(i) - 'a';
            if ((checker & (1 << val)) > 0) {
                return false;
            } else {
                checker |= (1 << val);
            }
        }
        return true;
    }

    // Using a hashmap
    static boolean allUniqueCharactersWithSet(String check) {
        Set<String> charactersSoFar = new HashSet<>();

        String currentCharacter;
        for (int i = 0; i < check.length(); i++) {
            currentCharacter = check.substring(i, i + 1);
            if (charactersSoFar.contains(currentCharacter)) {
                return false;
            } else {
                charactersSoFar.add(currentCharacter);
            }
        }
        return true;
    }

    // using sorting
    static boolean allUniqueCharacters(String check) {
        if (check.length() == 0) {
            return true;
        }
        String sortedString = sortString(check);

        String previousCharacter = sortedString.substring(0, 1);
        for (int i = 1; i < sortedString.length(); i++) {
            String currentCharacter = sortedString.substring(i, i + 1);
            if (previousCharacter.equals(currentCharacter)) {
                return false;
            } else {
                previousCharacter = currentCharacter;
            }
        }
        return true;
    }

    private static String sortString(String check) {
        char[] asArray = check.toCharArray();
        Arrays.sort(asArray);
        return String.valueOf(asArray);
    }

}
