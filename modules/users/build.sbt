import play.Project._

name := "users"

version := "1.0-SNAPSHOT"

libraryDependencies ++= Seq(
  "ws.securesocial" %% "securesocial" % "2.1.3"
)

playScalaSettings