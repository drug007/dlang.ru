void main() 
{
    import std.exception, std.stdio, std.process;
    auto result = ["whoami"].execute;
    enforce(result.status == 0);
    result.output.write;
}
---
import std.algorithm: map;
auto result = [1, 2, 3].map!(a => a + 1);
assert(result.equal([2 ,3, 4]));
---			
import vibe.vibe;
void main()
{
    listenTCP(7, (conn) { conn.write(conn); });
    runApplication();
}
---
import std.stdio;
void main() 
{ 
    writefln("Hello World!");
}
---
import std.stdio; 
import std.file;
  
void main() { 
    File file = File("test.txt", "w"); 
    file.writeln("hello");
    file.
	close(); 
}
---
//Version (tag) and Version (level)
import std.stdio;  
void myFunction() { 
    version(1) writeln("version1"); 
    version(2) writeln("version2");     
}
  
void main() { 
    myFunction(); 
}
---
import std.algorithm: sort;
auto result = [1, 3, 2].sort!"a > b";
assert(result.equal([3, 2, 1]));
---
import std.algorithm: count, sort, uniq;
auto result = [1, 3, 2, 2, 3].sort().uniq.count;
assert(result == 3);
---
import std.algorithm: map, sum;
import std.range: chunks;
auto result = [1, 2, 3, 4].chunks(2).map!(sum);
assert(result.equal([3, 7])); 
---
void main(string[] args)
{
    [1, 2, 3, 4, 5].sum.writeln;
}