import scala.io.Source
import scala.collection.mutable.Queue
import scala.collection.mutable.HashMap

object PartOne {
    def pathfind(map: List[List[Int]], width: Int, length: Int, start: (Int, Int), end: (Int, Int)): Int = {
        var open = Queue(start)
        var closed = HashMap.empty[(Int, Int), Int]
        closed += (start -> 0)
        while (!open.isEmpty) {
            var node = open.dequeue()
            if (node == end) { return closed(node) }
            for ((dx, dy) <- List((1, 0), (0, 1), (-1, 0), (0, -1))) {
                var newnode = (node._1 + dx, node._2 + dy)
                if ((newnode._1 < length) && (newnode._2 <= width) && (newnode._1 >= 0) && (newnode._2 >= 0) && (!closed.contains((newnode._1, newnode._2)))) {
                    if ((map(newnode._2)(newnode._1) <= map(node._2)(node._1) + 1)) {
                        open.enqueue((newnode._1, newnode._2))
                        closed += ((newnode._1, newnode._2) -> (closed(node) + 1))
                    }
                }
            }
        }; -1
    }

    def main(args: Array[String]) = {
        val fp: Source = Source.fromFile("input.txt")

        var start, end: (Int, Int) = (0, 0) 
        var width, length: Int = 0
        var line: List[Int] = List()
        var map: List[List[Int]] = List()
        while (fp.hasNext) {
            var c: Char = fp.next()
            if (c == '\n') {
                map = map :+ line
                line = List()
                width += 1
                length = 0

            } else {
                if (c == 'S') { 
                    start = (length, width)
                    line = line :+ 97 
                } else if (c == 'E') { 
                    end = (length, width)
                    line = line :+ 122
                } else { line = line :+ c.toByte }
                length += 1
            }
        }
        fp.close()

        println(pathfind(map :+ line, width, length, start, end))
    }
}
