package arrays_and_strings;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _6 {
    // String Compression: Implement a method to perform basic string
    // compression using the counts of repeated characters. For example,
    // the string aabcccccaaa would become a2blc5a3. If the "compressed"
    // string would not become smaller than the original string, your
    // method should return the original string. You can assume the
    // string has only uppercase and lowercase letters (a - z).
    // Hints:#92, #110
    public static String compressString(String original) {
        if (original.length() == 0) {
            return original;
        }
        StringBuilder compressed = new StringBuilder();
        char[] asCharArray = original.toCharArray();
        char lastLetter = asCharArray[0];
        int letterCount = 1;
        for (int i = 1; i < asCharArray.length; i++) {
            char currentLetter = asCharArray[i];
            if (currentLetter == lastLetter) {
                letterCount++;
            } else {
                // add the count and the last letter, then reset the counter.
                compressed.append(lastLetter);
                compressed.append(letterCount);
                letterCount = 1;
                lastLetter = currentLetter;
            }
        }
        compressed.append(lastLetter);
        compressed.append(letterCount);
        String asCompressed = compressed.toString();
        if (asCompressed.length() < original.length()) {
            return asCompressed;
        } else {
            return original;
        }
    }
}
