package trees_and_graphs;

import org.junit.Test;

import java.util.Arrays;
import java.util.List;

import static java.util.Arrays.*;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class _7Test {

    @Test
    public void test() {
        // Input: projects: a, b, c, d, e, f
        // dependencies: (a, d), (f, b), (b, d), (f, a), (d, c)

        List<Character> projects = asList('a', 'b', 'c', 'd', 'e', 'f');
        List<List<Character>> dependencies = asList(
                asList('a', 'd'),
                asList('f', 'b'),
                asList('b', 'd'),
                asList('f', 'a'),
                asList('d', 'c')
        );

        System.out.println(_7.findBuildOrder(projects, dependencies));

    }

}
