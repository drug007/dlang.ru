<template lang="pug">
    .container(v-html="this.book_content")
</template>

<script>
    import showdown  from  'showdown';
    //import GithubButton from 'vue-github-button'
    export default {
        name: 'Faq',
        data () {
            return {
                book_content: ''
            }
        },
        components:
            {
                //GithubButton
            },
        created()
        {
            this.$axios.get("/faq.md")
                .then(response => {
                    let converter = new showdown.Converter();
                    converter.setOption('customizedHeaderId', true);
                    this.book_content = converter.makeHtml(response.data)
                })
               .catch(() => console.log("Can't fetch book content from server: /faq.md"))
        }

    }
</script>

<style>

</style>