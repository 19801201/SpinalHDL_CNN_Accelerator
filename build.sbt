name := "spinal_yolo_dev"

version := "0.1"

scalaVersion := "2.11.12"

fork := true

libraryDependencies ++= Seq(
    "com.github.spinalhdl" % "spinalhdl-core_2.11" % "1.7.2",
    "com.github.spinalhdl" % "spinalhdl-lib_2.11" % "1.7.2",
    compilerPlugin("com.github.spinalhdl" % "spinalhdl-idsl-plugin_2.11" % "1.7.2"),
    "com.google.code.gson" % "gson" % "2.7"
)
