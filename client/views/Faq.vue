<template lang="pug">
    .container
        .gh-btns
            gh-btns-watch(slug="deviator/duseful", show-count)
            gh-btns-star(slug="deviator/duseful", show-count)
            gh-btns-fork(slug="deviator/duseful", show-count)
        div(v-html="this.book_content")
</template>

<script>
    import showdown  from  'showdown';
    import  {highlightDlang, replaceURLs } from "../funcs";

    export default {
        name: 'Faq',
        data () {
            return {
                book_content: ''
            }
        },
        created()
        {
            const reqOne = this.$axios.get('https://raw.githubusercontent.com/deviator/duseful/master/manuals/noobfaq.md');
            const reqTwo = this.$axios.get('https://raw.githubusercontent.com/deviator/duseful/master/manuals/faq.md');

            this.$axios.all([reqOne, reqTwo])
                .then(this.$axios.spread((...responses) => {
                    let converter = new showdown.Converter();
                    let data = responses[0].data + responses[1].data;
                    data = converter.makeHtml(data);
                    data = data.replace(/(<a.+?href=('|")(?!http))/g, '$1https://github.com/deviator/duseful/blob/master/');
                    data = data.replace(/(<img.+?src=('|")?(?!http))(\.\.)/g, '$1https://raw.github.com/deviator/duseful/master/');
                    data = data.replace(/<a\s/g, '<a target="_blank" ');
                    data = replaceURLs( data );
                    this.book_content = highlightDlang( converter.makeHtml(data) );
                }))
               .catch(() => console.log("Can't fetch book content from server"))
        }

    }
</script>

<style>

</style>