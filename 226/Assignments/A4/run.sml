Control.Print.printLength := 1000; (* set printing parameters so that *)
Control.Print.printDepth := 1000; (* we’ll see all details *)
Control.Print.stringDepth := 1000; (* and strings *)
CM.make "while.cm";
val a = While.compile "testcase.txt";
val exit : unit = OS.Process.exit(OS.Process.success);
