<template>
  <el-container style="display: flex; flex-direction: column;">
        <div style="align-self: flex-end;">
          <github-button data-size="large" href="https://github.com/bubnenkoff/dlang.ru/fork" data-icon="octicon-repo-forked">Fork</github-button>
          <github-button href="https://github.com/bubnenkoff/dlang.ru" data-icon="octicon-star" data-size="large" data-show-count="true">Star</github-button>
        </div>
        <el-main style='height: 100%; background-color: #f5f5f5;'>
           <markdown-it-vue class="md-body" :content="book_content"/>  
        </el-main>      
  </el-container>
</template>

<script>
import MarkdownItVue from 'markdown-it-vue'
import GithubButton from 'vue-github-button'

export default {
  name: 'app',
  data () {
    return {
      book_content: ''
    }
  },

  components: 
  {
      MarkdownItVue,
      GithubButton
  },

  created()
  {
    this.$axios.get(base_url + "/api/book")
    .then(response => this.book_content = response.data)
    .catch(error => console.log("Can't fetch book content from server: ", base_url + "/api/book")) 
  }
  
}
</script>

<style scoped>

.el-aside
{
  background-color: #eddecb;
  color: #333;
  text-align: center;
}

/*  mobile (all devices except that have mouse or touch pad  */
.md-body
{
  width: 100%;
  font-size: 1.3em;
}

@media (hover: hover) and (pointer: fine) {
  .md-body
  {
    width: 90%;
  }

}

</style>
