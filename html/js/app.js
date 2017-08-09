window.onload = function() {

	new Vue({
	  el: '#app',
	  data: {
	     all_content: ''
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

	})

}