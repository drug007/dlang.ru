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
    import {replaceURLs} from "../funcs";

    export default {
        name: 'Links',
        data () {
            return {
                book_content: ''
            }
        },
        created()
        {
            this.$axios.get("https://raw.githubusercontent.com/deviator/duseful/master/README.md")
                .then(response => {
                    let converter = new showdown.Converter();
                    let data = converter.makeHtml(response.data);
                    data = data.replace(/(<a.+?href=('|")(?!http))/g, '$1https://github.com/deviator/duseful/blob/master/');
                    data = data.replace(/<a\s/g, '<a target="_blank" ');
                    data = replaceURLs( data );
                    this.book_content = data;
                })
               .catch(() => console.log("Can't fetch book content from server: https://raw.githubusercontent.com/deviator/duseful/master/README.md"))
        }

    }
</script>

<style>

</style>