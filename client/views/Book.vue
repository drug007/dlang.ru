<template lang="pug">
    .container
        div(v-html="this.book_content")
</template>

<script>
    import Showdown from 'showdown';
    import {highlightDlang} from "../funcs";

    export default {
        name: 'Book',
        data () {
            return {
                book_content: ''
            }
        },
        created()
        {
            this.$axios.get( __PUBLIC_DIR__ + 'book.md')
                .then(response => {
                    let converter = new Showdown.Converter();
                    converter.setOption('customizedHeaderId', true);
                    this.book_content = highlightDlang( converter.makeHtml(response.data) );
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