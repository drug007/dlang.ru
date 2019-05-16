<template>
  <el-container>
    <!-- <side-bar></side-bar> -->
    <el-main>
       <markdown-it-vue class="md-body" :content="faq_content"/>
    </el-main>
  </el-container>

</template>

<script>

import SideBar from '../components/SideBar'
import MarkdownItVue from 'markdown-it-vue' // https://github.com/ravenq/markdown-it-vue

export default {
  name: 'app',
  data () {
    return {
      faq_content: ''
    }
  },

  components:
  {
    SideBar,
    MarkdownItVue
  },

  created()
  {
    this.$axios.get(base_url + "/api/faq")
    .then(response => this.faq_content = response.data)
    .catch(error => console.log("Can't fetch faq content from server: ", base_url + "/api/faq")) 
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
