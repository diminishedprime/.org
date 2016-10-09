object Mark extends Enumeration {
  val BLANK = Value("_")
  val X = Value("X")
  val O = Value("O")
}

class TTTBoard(contents: List[String]) {

  val markContents = contents.foldLeft(List(): List[Mark.Value])((x, y) =>  Mark.withName(y) :: x)

  def winningMark(markValues: List[Mark.Value]) : Mark.Value = {
    if (markValues.forall(_ == Mark.X)) {
      return Mark.X
    } else if (markValues.forall(_ == Mark.O)) {
      return Mark.O
    } else {
      return Mark.BLANK
    }
  }

  def groups(): List[List[Mark.Value]] = {
    val horizontals = markContents.grouped(3).toList
    val diagonals = List(List(markContents(0), markContents(4), markContents(8)),
                         List(markContents(2), markContents(4), markContents(6)))
    val verticles = List(horizontals.foldLeft(List(): List[Mark.Value])((x, y) => y(0) :: x),
                         horizontals.foldLeft(List(): List[Mark.Value])((x, y) => y(1) :: x),
                         horizontals.foldLeft(List(): List[Mark.Value])((x, y) => y(2) :: x))
    return horizontals ++ verticles ++ diagonals
  }

  def winner(): Mark.Value = {
    val winningGroup = groups.find((x) => winningMark(x) != Mark.BLANK)
    if (winningGroup.isDefined) {
      winningMark(winningGroup.get)
    } else {
      Mark.BLANK
    }
  }

  override def toString: String = {
    var result = ""
    markContents.sliding(3,3).foreach { list =>
      list.foreach {mark =>
        result += mark + " "
      }
      result += "\n"
    }
    return result
  }

  def printStuff() = {
    println("Winner is:" + this.winner)
    println(this)
    //println(this.groups)
  }
}

new TTTBoard(List("X", "_", "_",
                  "_", "X", "_",
                  "_", "_", "X")).printStuff

new TTTBoard(List("O", "_", "_",
                  "_", "O", "_",
                  "_", "_", "O")).printStuff

new TTTBoard(List("X", "O", "_",
                  "_", "O", "_",
                  "_", "O", "X")).printStuff
