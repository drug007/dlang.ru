<template lang="pug">
    div
        fixed-header
            header
                .container
                    router-link.logo(to="/"): img(src="@/assets/dlogo.svg", alt="Dlang.ru")
                    nav
                        router-link(to="/") Главная
                        router-link(to="/faq") FAQ
                        router-link(to="/links") Ссылки
                        router-link(to="/book") Online-учебник
                        a(href="https://t.me/dlangru" target="_blank")
                            | Мы в telegram
                            img(src="@/assets/img/telegram.svg", alt="")
        .header-substrate
        router-view
        back-to-top(text="", bottom="25px", right="13px")
</template>

<script>
import FixedHeader from 'vue-fixed-header';
import BackToTop from 'vue-backtotop'

export default {
    name: 'App',
    components: {
        FixedHeader,
        BackToTop
    }
}
</script>

