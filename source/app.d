import vibe.vibe;
import dini;
import std.conv;
import std.file;
import std.path;
import std.random;

// Все проще чем ты думаешь!
void main()
{
	auto ini = Ini.Parse("config.ini");
	auto settings = new HTTPServerSettings;
	settings.port = to!ushort(ini.getKey("port"));
	settings.bindAddresses = [ini.getKey("ipv6"), ini.getKey("ipv4")];

	auto router = new URLRouter;
	router.get("/api/book", &bookAPI);
	router.get("/api/faq", &faqAPI);
	router.get("/api/code-snippets", &codeSnippetsAPI);
	router.get("*", serveStaticFiles("web/dist/"));	
	router.get("*", serveIndex("web/dist/")); // pass all other path trough Vue

	listenHTTP(settings, router);
	runApplication();
}

void bookAPI(HTTPServerRequest req, HTTPServerResponse res)
{
	//res.headers["Access-Control-Allow-Origin"] = "*";
	string bookText; 
	bookText = readText(thisExePath().dirName() ~ "/text/book.md");
	res.writeBody(bookText);
}

void faqAPI(HTTPServerRequest req, HTTPServerResponse res)
{
	//res.headers["Access-Control-Allow-Origin"] = "*";
	string faqText; 
	faqText = readText(thisExePath().dirName() ~ "/text/faq.md");
	res.writeBody(faqText);
}

void codeSnippetsAPI(HTTPServerRequest req, HTTPServerResponse res)
{
	//res.headers["Access-Control-Allow-Origin"] = "*";
	string snippetsText; 
	snippetsText = readText(thisExePath().dirName() ~ "/text/snippets.md");
	auto snippetsTextArray = snippetsText.split("---"); // --- separatos between snipets
	int randomNumber = uniform(0,to!int(snippetsTextArray.length)); 
	res.writeBody(snippetsTextArray[randomNumber]); // return single snippets 
}

HTTPServerRequestDelegateS serveIndex(string path, HTTPFileServerSettings settings = null)
{
	import vibe.core.path: NativePath;
	import vibe.http.fileserver: sendFile;

  void callback(scope HTTPServerRequest req, scope HTTPServerResponse res)
  {
    sendFile(req, res, NativePath(path), settings);
  }

  return &callback;
}