window.onload = function() {

	const NotFound = { template: '<p>Page not found</p>' }
	const Home = { template: '<p>home page</p>' }
	const Faq = { template: '<p>Faq page</p>' }
	const Book = { template: `
	<div>
			<div class="bookContent">
			<div v-html="all_content"></div>
			</div>
	</div>`, 
	data() {
		return {
		 all_content: ''
		}
	},
	methods: 
	  {
	  	LoadData()
	  	{
	  	  this.$http.get('/data').then(response => {
  		  this.all_content = response.body.content;

		  }, response => {
		    console.log(response.code);
		  });
	  	}
	  },

	 mounted()
	 {
	 	this.LoadData();
	 } 

	}


	const routes = [
	  {path: '/', component: Home},
	  {path: '/book', component: Book},
	  {path: '/faq', component: Faq}
	]

	const router = new VueRouter({
  		routes, // short for `routes: routes`
  		mode: 'history'
		})

	new Vue({
	  el: '#app',
	  router,
	  data: {
	    
	  },

	})

}