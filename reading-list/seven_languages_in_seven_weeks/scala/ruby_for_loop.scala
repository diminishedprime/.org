def rubyStyleForLoop {
  println( "for loop using Ruby-style iteration" )
  args.foreach { myArg =>
    println(myArg)
  }
}
rubyStyleForLoop
