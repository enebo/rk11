# Run with MRI rake since we default to jruby.launcher.inproc=true

task :run_java do
  system 'java -Djava.library.path=lib/lwjgl/native/macosx -cp lib/ardor3d-awt-0.8-SNAPSHOT.jar:lib/lwjgl/lwjgl.jar:lib/guava-r07.jar:dist/rk11.jar:lib/ardor3d-lwjgl-0.8-SNAPSHOT.jar:lib/ardor3d-jogl-0.8-SNAPSHOT.jar:lib/ardor3d-core-0.8-SNAPSHOT.jar:lib/ardor3d-examples-0.8-SNAPSHOT.jar:lib/ardor3d-ui-0.8-SNAPSHOT.jar:lib/lwjgl/jinput.jar com.ardor3d.example.benchmark.ball.BubbleMarkUIExample'
end

task :run_ruby do
  puts "Running Ruby version"
  system 'jruby --server -J-Djava.library.path=lib/lwjgl/native/macosx bubble_mark_example.rb'
end
