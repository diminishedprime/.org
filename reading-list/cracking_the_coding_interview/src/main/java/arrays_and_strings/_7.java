package arrays_and_strings;

/**
 * Created by mjhamrick on 12/16/16.
 */
public class _7 {
    // Rotate Matrix: Given an image represented by an NxN matrix,
    // where each pixel in the image is 4 bytes, write a method to
    // rotate the image by 90 degrees. Can you do this in place?
    // Hints:#51, #100
    public static void rotate90(byte[][] image) {
        //normally, there should be some sort of check to make
        // sure the image is valid. i.e 4x4 pixels
        for (int i = 0; i < image.length / 2; i +=2) {
            for (int j = 0; j < image[i].length / 2; j+=2) {
                int x = j;
                int y = i;
                byte previousTopLeft = image[y][x];
                byte previousTopRight = image[y][x + 1];
                byte previousBottomLeft = image[y + 1][x];
                byte previousBottomRight = image[y + 1][x + 1];

                for (int k = 0; k < 4; k++) {
                    int moveX = 0;
                    int moveY = 0;
                    switch (k) {
                        case 0:
                            break;
                        case 1:
                            moveX = image.length / 2;
                            break;
                        case 2:
                            moveX = image.length / 2;
                            moveY = image.length / 2;
                            break;
                        case 3:
                            moveY = image.length / 2;
                            break;
                    }
                    byte currentTopLeft = image[y + moveY][x + moveX];
                    byte currentTopRight = image[y + moveY][x + moveX + 1];
                    byte currentBottomLeft = image[y + moveY + 1][x + moveX];
                    byte currentBottomRight = image[y + moveY + 1][x + moveX + 1];


                    image[y + moveY][x + moveX] = previousTopLeft;
                    image[y + moveY][x+ moveX + 1] = previousTopRight;
                    image[y + moveY + 1][x + moveX] = previousBottomLeft;
                    image[y + moveY + 1][x + moveX + 1] = previousBottomRight;

                    previousTopLeft = currentTopLeft;
                    previousTopRight = currentTopRight;
                    previousBottomLeft = currentBottomLeft;
                    previousBottomRight = currentBottomRight;
                }
                image[y][x] = previousTopLeft;
                image[y][x + 1] = previousTopRight;
                image[y + 1][x] = previousBottomLeft;
                image[y + 1][x + 1] = previousBottomRight;
            }
        }
    }
}
