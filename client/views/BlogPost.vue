<template lang="pug">
    .container
        div(v-html="this.blog_content")
</template>

<script>
    import Showdown from 'showdown';
    import { highlightDlang, replaceURLs } from '../funcs';

    export default {
        name: 'BlogPost',
        data () {
            return {
                blog_content: ''
            }
        },
        created()
        {
            let rName = this.$route.params.name;
            let matches = rName.match( /^(.*)\.html$/)
            if ( matches )
                rName = matches[1] + '.md';
            else
                rName += '/README.md';

            this.$axios.get(__PUBLIC_DIR__ + "blog/" + rName)
                .then(response => {
                    let converter = new Showdown.Converter();
                    converter.setOption('customizedHeaderId', true);
                    let data = highlightDlang( converter.makeHtml(response.data) );
                    data = data.replace(/<a\s/g, '<a target="_blank" ');
                    data = replaceURLs( data );
                    data = data.replace(/(<img.+?src=('|")(?!http))/g, '$1/public/' + window.location.pathname + '/');
                    this.blog_content = data;
                })
               .catch((error) => {
                   console.log(error);
               })
        }
    }
</script>

<style>

</style>