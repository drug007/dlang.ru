import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router);

import Main from '../views/Main.vue'
import NotFound from '../views/NotFound.vue'
import Faq from '../views/Faq.vue'
import Blog from '../views/Blog.vue'
import BlogPost from '../views/BlogPost.vue'
import Book from '../views/Book.vue'
import Links from '../views/Links.vue'


export default new Router({
    mode: 'history',
    base: process.env.BASE_URL,
    routes: [
        {
            path: '/',
            component: Main
        },
        {
            path: '/book',
            component: Book
        },
        {
            path: '/blog',
            component: Blog
        },
        {
            path: '/blog/:name',
            component: BlogPost
        },
        {
            path: '/faq',
            component: Faq
        },
        {
            path: '/links',
            component: Links
        },
        {
            path: '/404',
            component: NotFound,
        },
        {
            path: '*',
            redirect: '/404'
        }
    ]
})
