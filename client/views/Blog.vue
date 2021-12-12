<template lang="pug">
    #blog.container
        div(v-html="this.blog_content")
</template>

<script>
    import Showdown from 'showdown';

    export default {
        name: 'Blog',
        data () {
            return {
                blog_content: ''
            }
        },
        created()
        {
            this.$axios.get(__PUBLIC_DIR__ + "blog/README.md")
                .then(response => {
                    let converter = new Showdown.Converter();
                    converter.setOption('customizedHeaderId', true);
                    let data = converter.makeHtml(response.data);
                    this.blog_content = data;
                })
               .catch((error) => {
                   console.log(error);
               })
        },
        updated() {
            [...document.getElementById("blog").getElementsByTagName('a')]
                .forEach(( a ) => {
                    a.onclick = (e) => {
                        const href = a.getAttribute("href");
                        if ( !href.match(/^http/) )
                        {
                            e.preventDefault();
                            this.$router.push(a.getAttribute("href"));
                        }
                    };
                });
        }
    }
</script>

<style>

</style>