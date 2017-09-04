import vibe.vibe;
import parser;
import std.file, std.path;

Json answer;
string bookText;

void main()
{
	bookText = readText(thisExePath().dirName() ~ "/book/book.md");
	auto settings = new HTTPServerSettings;
	settings.port = 8082;
	settings.bindAddresses = ["127.0.0.1"];

	auto router = new URLRouter;
	router.get("*", serveStaticFiles("html/"));
	router.get("/", staticTemplate!"home.dt");
	router.get("/faq", staticTemplate!"faq.dt");
	router.get("/book", staticTemplate!"book.dt");
	router.get("/data", &data);

	answer = convertMD2HTMLReturnJSON(bookText);

	listenHTTP(settings, router);
	logInfo("Please open http://127.0.0.1/ in your browser.");
	runApplication();
}

//void home(HTTPServerRequest req, HTTPServerResponse res)
//{
//	res.render!("index.dt");
//}


void data(HTTPServerRequest req, HTTPServerResponse res)
{
	res.writeJsonBody(answer);
}
