import akka.actor.{Actor, ActorRef, ActorSystem, Props}
import scala.io.Source
import scala.concurrent.{Future, ExecutionContext}
import scala.util.{Success, Failure}

// Сообщения для актора
case class ProcessChunk(chunk: List[String])
case class ChunkResult(results: List[Int])
case object GetResult

// Актор для обработки чанка данных
class ChunkProcessor extends Actor {
  def receive = {
    case ProcessChunk(chunk) =>
      val results = chunk.map(processLine)
      sender() ! ChunkResult(results)
  }
  
  def processLine(line: String): Int = {
    // Суммирование всех цифр в строке
    line.filter(_.isDigit).map(_.asDigit).sum
  }
}

// Главный актор
class MainActor(numChunks: Int) extends Actor {
  var results: List[Int] = List.empty
  var receivedChunks: Int = 0
  
  def receive = {
    case ChunkResult(chunkResults) =>
      results = results ++ chunkResults
      receivedChunks += 1
      if (receivedChunks == numChunks) {
        val total = results.sum
        println(s"Обработано строк: ${results.length}")
        println(s"Общая сумма: $total")
        context.system.terminate()
      }
    case GetResult =>
      sender() ! results
  }
}

object ParallelProcessing {
  def main(args: Array[String]): Unit = {
    if (args.length != 1) {
      println("Использование: scala ParallelProcessing <файл>")
      sys.exit(1)
    }
    
    val filename = args(0)
    val lines = Source.fromFile(filename).getLines().toList
    
    implicit val system: ActorSystem = ActorSystem("ParallelProcessingSystem")
    implicit val ec: ExecutionContext = system.dispatcher
    
    val numProcessors = Runtime.getRuntime.availableProcessors()
    val chunkSize = (lines.length + numProcessors - 1) / numProcessors
    val chunks = lines.grouped(chunkSize).toList
    
    println("=== Использование акторов ===")
    val mainActor = system.actorOf(Props(new MainActor(chunks.length)), "mainActor")
    
    // Создаем акторы для обработки чанков
    chunks.zipWithIndex.foreach { case (chunk, index) =>
      val processor = system.actorOf(Props[ChunkProcessor], s"processor-$index")
      processor.tell(ProcessChunk(chunk), mainActor)
    }
    
    // Используем Future для асинхронной обработки
    println("\n=== Использование Future ===")
    val futures = chunks.map { chunk =>
      Future {
        chunk.map(line => line.filter(_.isDigit).map(_.asDigit).sum)
      }
    }
    
    val combinedFuture = Future.sequence(futures)
    
    combinedFuture.onComplete {
      case Success(allResults) =>
        val flatResults = allResults.flatten
        val total = flatResults.sum
        println(s"Обработано строк: ${flatResults.length}")
        println(s"Общая сумма: $total")
        system.terminate()
      case Failure(e) =>
        println(s"Ошибка: $e")
        system.terminate()
    }
    
    // Ждем завершения работы
    Thread.sleep(3000)
    if (!system.whenTerminated.isCompleted) {
      system.terminate()
    }
  }
}

