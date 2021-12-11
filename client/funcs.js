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
    return text.replace(/\b((?<!((href)|(src))=('|"))https?:\/\/[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|])/ig, '<a href="$1" target="_blank">$1</a>');
}