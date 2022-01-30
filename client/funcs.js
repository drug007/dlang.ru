import hljs from 'highlight.js/lib/highlight';
import d from 'highlight.js/lib/languages/d';
hljs.registerLanguage('d', d);
import 'highlight.js/styles/monokai-sublime.css';

export function highlightDlang ( text )
{
    return text.replace(

        /(<pre><code.+?class=".*?language-d.*?)(">)(.*?)(<\/code><\/pre>)/gs,
        (m, p1, p2, p3, p4) => {
            // fix issue #1
            let hl = hljs.highlight("d", p3).value;
            hl = hl.replace(/&amp;((?:gt|lt|amp);)/g, '&$1');
            return p1 + " hljs" + p2 + hl + p4;
        }
    );
}

export function replaceURLs ( text ) {
    // fix issue #5 Safari: Invalid regular expression: invalid group specifier name
    // /\b((?<!((href)|(src))=('|"))https?:\/\/[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|])/ig
    return text.replace(/([^=][^'"])(https?:\/\/[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|])/ig, '$1<a href="$2" target="_blank">$2</a>');
}