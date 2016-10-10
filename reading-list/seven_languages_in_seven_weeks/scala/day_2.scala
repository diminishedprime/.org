println("Using foreach with a List")
val list = List("Frodo", "samwise", "pippin")
list.foreach(hobbit => println(hobbit))
println

println("Using foreach with a Map\n")
val hobbits = Map("Frodo" -> "hobbit",
                  "Samwise" -> "hobbit",
                  "Pippin" -> "hobbit")
println("foreach using the whole tuple")
hobbits.foreach(hobbit => println(hobbit))
println

println("foreach using part of the tuple")
hobbits.foreach(hobbit => println(hobbit._1))
println

println("foldleft with magic operator")
val list2 = List(1, 2, 3)
val sum = (0 /: list2) {(sum, i) => sum + i}
println(sum)
println

println("foldleft with currying")
println(list2.foldLeft(0)((sum, value) => sum + value))
println

// Do

// Use foldLeft to compute the total size of a list of strings.
println("Use foldLeft to compute the total size of a list of strings.")
val words = List("Word1", "Other Word", "potato")
val totalLength= words.foldLeft(0)((acc, current) => acc + current.length)
println(words)
println(totalLength)
println

// Write a Censor trait with a method that will replace the curse words Shoot
// and Darn with Pucky and Beans alternatives. Use a map to store the curse
// words and their alternatives.
println("Write a Censor trait with a method that will replace the curse words Shoot and Darn with Pucky and Beans alternatives. Use a map to store the curse words and their alternatives.")

import collection.mutable.HashMap

trait Censor {
  val curseWords = new HashMap[String, String]

  io.Source.fromFile("censor.txt").getLines().foreach { line =>
    val parts = line.split(": ")
    curseWords += parts(0) -> parts(1)
  }

  def censor(s: String) = curseWords.foldLeft(s) ((prev, curr) =>
    prev.replaceAll(curr._1, curr._2))
}

class Text(s: String) extends Censor {
  def value = s
  def censoredValue = censor(s)
}
val text = new Text("Shoot, I forgot my Darn traits again")
println("Original String: " + text.value)
println("Censored String: " + text.censoredValue)
