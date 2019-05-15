import Router from 'vue-router'

import IndexPage from './pages/IndexPage'
import FaqPage from './pages/FaqPage'
import BookPage from './pages/BookPage'

const router = new Router({
    'mode': 'history',
    'routes': [
        {
            path: '/',
            component: IndexPage,
        },
        {
            path: '/faq',
            component: FaqPage,
        },
        {
            path: '/book',
            component: BookPage,
        },        

    ],
    scrollBehavior() {
        return {x: 0, y: 0}
    }
})

export default router