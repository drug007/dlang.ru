<template lang="pug">
    .container
        .gh-btns
            gh-btns-watch(slug="bubnenkoff/dlang.ru", show-count)
            gh-btns-star(slug="bubnenkoff/dlang.ru", show-count)
            gh-btns-fork(slug="bubnenkoff/dlang.ru", show-count)
        div(v-html="this.book_content")
</template>

<script>
    import Showdown from 'showdown';
    //import Prism  from 'prismjs';

    export default {
        name: 'Book',
        data () {
            return {
                book_content: ''
            }
        },
        created()
        {
            this.$axios.get("/book.md")
                .then(response => {
                    let converter = new Showdown.Converter();
                    converter.setOption('customizedHeaderId', true);
                    let data = converter.makeHtml(response.data);
                    /*let loadLanguages = require('prismjs/components/');
                    loadLanguages(['d']);
                    data = Prism.highlight(data, Prism.languages.d, 'd');*/
                    this.book_content = data;
                })
               .catch((error) => {
                   console.log("Can't fetch book content from server: /book.md");
                   console.log(error);
               })
        }

    }
</script>

<style>

</style>