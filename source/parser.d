import vibe.data.json;
import std.stdio;
import std.string;
import std.file;
import std.conv;
import std.regex;
import std.uuid;
import std.algorithm;


Json convertMD2HTMLReturnJSON(string text)
{
    int JsonOrder;
    auto inlineCodeBlock = regex(r"`([^`\s\n]+)`");
    auto bigCodeBlock = regex(r"`{3}(.+?)`{3}","s");
    auto headerBlock = regex(r"(#.+)", "s");
    auto tipsBlock = regex(r"(>\*\*Tips:\*\* .+)", "s");
    auto brBlock2 = regex(`\n\n`, "s"); // remove br twice
    auto brBlock1 = regex(`\n`, "s"); // remove br twice

    string content;
    string tableOfContent;
    auto re = ctRegex!(`^(#+).+?$.+?(?:(?=^#)|$(?!.))`, "ms");
    int[] nums;

    foreach (m; text.replace(`<`,`&lt;`).replace(`>`, `&gt;`).matchAll(re)) 
    {
        auto len = m[1].length;
        while (nums.length && nums[$ - 1] >= len) 
        {
            content ~= "</div " ~ ">" ~ "\n";
            nums = nums[0..$ - 1];
        }
        nums ~= len.to!int;
        string myGUID = randomUUID().to!string.split("-")[0];
        
        content ~= "<div " ~ `id="` ~ myGUID ~ `"` ~ ` class="bookcontent">`; // <div id="ca1527fd">

        content ~= to!string(m[0]).
                                replaceAll(inlineCodeBlock, r"<inlineCodeBlock>$1</code>")
                                .replace(`<inlineCodeBlock>`, `<code class="inlineCodeBlock">`)
                                .replaceAll(bigCodeBlock, r"<bigCodeBlock>$1</code>")
                                .replace(`<bigCodeBlock>`, `<code class="language-d">`);
                                

        //content = std.array.replace(content, "\n", ""));

        //writeln(std.array.replace(content, "\n", ""));
        //writeln("fff");
        //readln;
                      
    }

    foreach_reverse (len; nums) 
    {
        content ~=  "</div>" ; //~ "\n";
    }


    string new_content; // fixing H1 sections

    foreach(line; content.lineSplitter)
    {
        if(line.startsWith("<div ")) // example: 
        {
            string level = line.count("#").to!string;
            new_content ~=  line.replaceAll(headerBlock, r"<h_level>$1</h_level>").replace("_level", level);
        }    
        else
        {
            if(line.startsWith(">**"))
                new_content ~= "<br/>" ~ line; // ~ "\n";
            else
            {
                //if(!line.canFind(`<br>`))
                    new_content ~= line ~ "\n";
                //else
                //new_content ~= line;
            }
        }

    }

    string new_content2 = new_content.replaceAll(brBlock2, `<br>`).replaceAll(brBlock1, `<br>`);

    // content содержит все данные, а нам нужно при каждой итерации все в массив contentJson класть


    foreach(line; content.lineSplitter) // only for creation ToC // Работает!!!   "e1c4030a": {"itemName": "###Наследование",  "JsonOrder": 45, "level": "3" }
    {
        if(line.startsWith("<div ")) // example: 
        {
            string level = line.count("#").to!string;
            string myGUID = line[9..17]; // выкусываем guid
            string myid = `id="` ~ myGUID ~ `"`; // пока не используется
            string itemName = line.split(`">`)[1]; //имя пункта. К примеру: ##Наследование
            tableOfContent ~= `<li><a href=#` ~ myGUID ~ `>` ~ itemName ~ `</a><li>` ~ "\n";
             
        }
    }


    //std.file.write("output.txt", tableOfContent ~ "\n" ~ content);

    Json mydata = Json.emptyObject;
    mydata["content"] = `<ul>` ~ tableOfContent ~ `</ul>` ~ "\n" ~ new_content2;
    //std.file.write("output.txt", new_content2);
    return mydata;
}













