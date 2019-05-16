<template>
  <el-container>
    <side-bar></side-bar>
    <el-main>
      <div class="top">
        <div class="download-compiler">
            <div class="dmd-download">
                <el-image src="./images/dmd_logo.webp"></el-image>
                <el-link href="https://dlang.org/download.html" style="color: black; font-size: 1.3em;">DMD</el-link>
            </div>
            <div class="ldc-download">
                <el-image src="./images/ldc_logo.webp"></el-image>
                <el-link href="https://dlang.org/download.html" style="color: black; font-size: 1.3em;">LDC</el-link>
            </div>
        </div>
        <div class="code-snippets">
          <div class="code-snippets-header">
            Примеры:
          </div>

            <highlight language="d" style="text-align: left;" >{{codeSnippets}}</highlight>

        </div>
      </div>

      <div class="middle">
        <div class="main-app-img">
          <el-image src="./images/main-app.webp" ></el-image>  
        </div>
        
      </div>

    </el-main>
  </el-container>
</template>

<script>
import SideBar from '../components/SideBar'

import hljs from 'highlight.js'
import Highlight from 'vue-highlight-component'

// Register the language if it's not supported by default
hljs.registerLanguage('swift', require('highlight.js/lib/languages/d'))


export default {
  name: 'app',
  data () {
    return {
      msg: 'Root Page Content',
      codeSnippets: ''
    }
  },
  components:
  {
    SideBar,
    Highlight,

  },

  created()
  {
    this.$axios.get(base_url + "/api/code-snippets")
    .then(response => this.codeSnippets = response.data)
    .catch(error => console.log("Can't fetch code-snippets content from server: ", base_url + "/api/code-snippets")) 
  }

}
</script>

<style scoped>

.top
{
  background-color: #f2f2f2;
  color: #333;
  text-align: center;
 /* height: 20%;*/
  display: flex;
}

.middle
{

  background-color: #f2f2f2;
  flex-grow: 1;
  
}

.el-main
{
  background-color: #f2f2f2;
  display: flex;
  flex-direction: column;
}

.download-compiler
{
  display: flex;
  justify-content: flex-end;
  flex-grow: 0.4;
  flex-direction: row;
  
}

.code-snippets
{
  display: flex;
  flex-direction: column;
  /*border: 1px black dashed;*/
  flex-grow: 0.6;
}

.code-snippets-content
{
  background: #e6e4dc;
  height: 100%;
  width: 100%;
}

.dmd-download, .ldc-download
{
  padding-top: 10px;
  padding-right: 5px;
  display: flex;
  flex-direction: column;

}

.main-app-img
{
  display: flex;
  justify-content: center;
  padding-top: 2%;
  flex-grow: 1;
}

code
{
  font-size: 1.2em;
}

.el-image
{
  max-width:80%;
  max-height:80%;
}

</style>


