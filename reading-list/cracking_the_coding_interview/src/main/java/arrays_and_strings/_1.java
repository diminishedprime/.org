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
