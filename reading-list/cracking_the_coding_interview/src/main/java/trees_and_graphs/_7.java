package trees_and_graphs;

import java.util.*;

public class _7 {

    // Build Order: You are given a list of projects and a list of dependencies
    // (which is a list of pairs of projects, where the second project is
    // dependent on the rst project). All of a project's dependencies must be
    // built before the project is. Find a build order that will allow the
    // projects to be built. If there is no valid build order, return an error.

    // EXAMPLE
    // Input: projects: a, b, c, d, e, f
    // dependencies: (a, d), (f, b), (b, d), (f, a), (d, c)

    // Output: f, e, a, b, d, c

    // Hints: #26, #47, #60, #85, #125, #133

    // This isn't exactly the same, but it's very similiar to the solution 1 from the book.
    public static LinkedList<Character> findBuildOrder(List<Character> projects, List<List<Character>> dependencies) {

        Map<Character, Set<Character>> depGraph = setUpGraph(projects, dependencies);

        return topologicalSort(depGraph);
    }

    private static LinkedList<Character> topologicalSort(Map<Character, Set<Character>> depGraph) {
        LinkedList<Character> buildQueue = new LinkedList<Character>();
        while (!depGraph.isEmpty()) {
            // iterate through the dep graph keyvaluepairs
            LinkedList<Character> newRemovals = new LinkedList<Character>();
            int queueSize = buildQueue.size();
            for (Map.Entry<Character, Set<Character>> entry : depGraph.entrySet()) {
                Character project = entry.getKey();
                Set<Character> projectDependencies = entry.getValue();
                if (projectDependencies.isEmpty()) {
                    buildQueue.addFirst(project);
                    newRemovals.push(project);
                }
            }
            // remove projects that are now in queue
            // remove the dependencies on these
            while (!newRemovals.isEmpty()) {
                Character toRemove = newRemovals.pop();
                removeNeededDep(depGraph, toRemove);
                depGraph.remove(toRemove);
            }

            if (queueSize == buildQueue.size()) {
                throw new RuntimeException("No valid dependency graph");
            }
        }
        return buildQueue;
    }

    private static Map<Character, Set<Character>> setUpGraph(List<Character> projects, List<List<Character>> dependencies) {
        Map<Character, Set<Character>> depGraph = new HashMap<>();

        for (Character c : projects) {
            depGraph.put(c, new HashSet<>());
        }
        for (List<Character> dep : dependencies) {
            // assuming a fixed size list
            Character dependency = dep.get(0);
            Character project = dep.get(1);
            depGraph.get(dependency).add(project);
        }
        return depGraph;
    }

    private static void removeNeededDep(Map<Character, Set<Character>> depGraph, Character project) {
        for (Map.Entry<Character, Set<Character>> entry : depGraph.entrySet()) {
            entry.getValue().remove(project);
        }
    }
}
