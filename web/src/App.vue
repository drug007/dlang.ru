<template>
  <div id="app">
    <el-container>
      <el-header>
        <el-menu :default-active="activeIndex" class="el-menu-demo" 
          mode="horizontal" @select="handleSelect" background-color="#545c64" text-color="#fff" active-text-color="#ffd04b"
          :router="true"
          >
           <el-menu-item index="/">Главная</el-menu-item>
           <el-menu-item index="faq">FAQ</el-menu-item>
           <el-menu-item index="book">Книга</el-menu-item>
        </el-menu>
      </el-header>
          <router-view></router-view>
      <el-footer height="40px">dlang.ru (c) 2019</el-footer>
    </el-container>
  </div>
</template>

<script>
    import router from './router'
    import Vue from 'vue'
    import IndexPage from './pages/IndexPage'
    import FaqPage from './pages/FaqPage'
    import BookPage from './pages/BookPage'
    
    import axios from 'axios'

    export default {
        name: 'app',
        router,
        components: {
            IndexPage,
            FaqPage,
            BookPage,
        },
    
    data() {
      return {
        activeIndex: '',
      };
    },

    methods:
    {
       handleSelect(key, keyPath) {
        // console.log(key, keyPath);
      }
    }

    }
</script>

<style>

html, body 
{
  height: 100%;
  margin: 0;
  padding: 0;
  border: 0;
  font-size: 16px;
  font: inherit;
  vertical-align: baseline;  
  font-family: "Roboto Slab", sans-serif;
}

.el-header
{
  background-color: #ced5df;
  color: #333;
  text-align: center;
  line-height: 60px;
  padding: 0;
  font-size: 1.4em;
}

/* for desktop (have mouse or touch pad) */
@media (hover: hover) and (pointer: fine) 
{
  body
  {
    width: 80%;
    margin: 0px auto;
    background-color: #e6e6e6; 
  }

  .el-header
  {
    background-color: #ced5df;
    color: #333;
    text-align: center;
    line-height: 60px;
    padding: 0;
    font-size: 1em;
  }

}

.el-container 
{
    height: 100vh;
    background-color: #f2f2f2;
}


.el-footer 
{
  background-color: #ced5df;
  color: #333;
  text-align: center;
  line-height: 40px;
  padding: 0;
}

</style>

