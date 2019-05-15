import './pages/assets/element-variables.scss'
import Vue from 'vue';
import App from './App.vue';
import ElementUI from 'element-ui'
import Router from 'vue-router'
import Axios from 'axios'

import 'prismjs'
import 'prismjs/themes/prism.css'

// change this for localization
//import locale from 'element-ui/lib/locale/lang/ru-RU'
//Vue.use(ElementUI, { locale })

globalThis.base_url = "http://127.0.0.1:8081"

Vue.use(ElementUI);
Vue.use(Router);

// Vue.use(MarkdownItToc)

Vue.prototype.$axios = Axios;

new Vue({
  el: '#app',
  // locale: 'ru',
  render: h => h(App)
});