package arrays_and_strings;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _3 {
    // URLify : Write a method to replace all spaces in a string with '%20
    // You may assume that the string has sufficient space at the end to hold the additional characters,
    // and that you are given the "true" length of the string.
    // (Note: If implementing in Java,please use a character array so that you can perform this operation in place.)
    // EXAMPLE Input: "Mr John Smith ", 13 Output: "Mr%20John%20Smith" Hints: #53, #118

    public static void urlIfy(char[] string, int trueLength) {

        if (string.length == trueLength) {
            return;
        }
        int lastCharIndex = trueLength - 1;
        for (int i = string.length - 1 ; i >= 0; i--) {
            char lastChar = string[lastCharIndex];
            if (lastChar == ' ') {
                string[i] = '0';
                string[i - 1] = '2';
                string[i - 2] = '%';
                i = i - 2;
            } else {
                string[i] = lastChar;
            }
            lastCharIndex--;
        }
    }
}
